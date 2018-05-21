import Foundation
import Alamofire
import SwiftyJSON

/**
 
 A singleton instance around an Alamofire Session to manage all HTTP requests made by the app.
 
 - Author:
    Pranay Neelagiri
 
 */

class RequestManager {
    
    static let shared = RequestManager()
    
    private init() {
        
    }
    
    /**
     
     Uses Alamofire to make an HTTP request without caching cookies, headers, or results and validates the response code. Wraps Alamofire method in case of future migration to URLSession or changing Alamofire implementation.
     
     - returns
     No return type
     
     - parameters:
        - url: A String containing the request URL
        - method: The type of HTTP method to associate with the request
        - completion: A closure to execute upon the successful execution of the HTTP request. Called with a DataResponse returned by the HTTP call
        - response: The HTTP response returned by Alamofire call to be passed into closure - acted on by callee
     
     */
    private func makeRequest(url:String, method: HTTPMethod, completion: @escaping (_ response:DataResponse<Any>) -> Void) {
        Alamofire.SessionManager.default.requestWithoutCache(url, method: method).validate().responseJSON { response in
            completion(response)
        }
    }
    
    /**
     
     Adds HTTP cookie to Alamofire Session
     
     - parameters:
        - cookie: The HTTP cookie to add to the Alamofire Session
     
     */
    
    func addCookie(cookie:HTTPCookie) {
        Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.setCookie(cookie)
    }
    
    /**
    Adds HTTP header to Alamofire Session
    
    - parameters:
        - value: The HTTP header value for the key
        - key: The HTTP header name to add to Alamofire
    
    */
    
    func addHeader(value: Any, key: AnyHashable){
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders?.updateValue(value, forKey: key)
    }
    
    /**
     
     Ends Sakai session by resetting Alamofire Session and uses main thread to reroute app control to LoginViewController. Optionally starts and stops a loading indicator on callee.
     
     - parameters:
        - indicator: An object of type LoadingIndicator that is optionally started and stopped
 
    */
    
    func logout(indicator:LoadingIndicator? = nil) {
        if indicator != nil {
            indicator!.startAnimating()
        }
        
        self.reset()
        AppGlobals.TO_RELOAD = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
            if indicator != nil {
                indicator!.stopAnimating()
            }
        })
    }
    
    /**
     
     Resets Alamofire session by flushing session configuration of all Cookies and Headers
     
    */
    
    func reset() {
        URLCache.shared.removeAllCachedResponses()
        Alamofire.SessionManager.default.session.configuration.urlCache?.removeAllCachedResponses()
        Alamofire.SessionManager.default.session.configuration.urlCache = nil
        let cookies:[HTTPCookie]! = Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.cookies
        for cookie in cookies {
            Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.deleteCookie(cookie)
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders?.removeValue(forKey: AnyHashable("X-Sakai-Session"))
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders?.removeAll()
    }
    
    /**
     
     Makes an HTTP request to determine if user is logged in. Sakai server returns valid response whether or not user is logged in, so result of check is passed into completion handler to be implemented by callee
     
     - parameters:
        - completion: A closure that is called with a Boolean result of whether the user is logged in or not
        - check: Boolean flag determining if user is logged in, passed into closure - acted on by callee
     
     */
    
    func isLoggedIn(completion: @escaping (_ check:Bool) -> Void)  {
        self.makeRequest(url: AppGlobals.SESSION_URL, method: .get) { response in
            var flag = false
            if let data = response.result.value {
                print("JSON: \(data)")
                let json = JSON(data)
                if json["userEid"].string != nil {
                    print("Flag set to true")
                    flag = true
                } else {
                    self.reset()
                    print("Flag is false")
                }
            }
            completion(flag)
        }
    }
    
    /**
 
    Makes an HTTP request to determine the list of sites the user is registered for. Instantiates and sorts Sites by Term to construct 2-dimensional array of sites. That array is passed into completion handler for callee to use as needed
     
    - parameters:
        - completion: A closure called with a [[Site]] object to be implemented by callee
        - site: A [[Site]] object passed into closure for callee to use as needed
     
     */
    
    func getSites(completion: @escaping (_ site: [[Site]]?) -> Void) {
         self.makeRequest(url: AppGlobals.SITES_URL, method: .get) { response in
            
            //print(response)
            guard let data = response.result.value else {
                print("error")
                return
            }
            
            var siteList:[Site] = [Site]()
            guard let sitesJSON = JSON(data)["site_collection"].array else {
                completion(nil)
                return
            }
            
            for siteJSON in sitesJSON {
                let site:Site! = Site(data: siteJSON)
                siteList.append(site)
                AppGlobals.siteTermMap.updateValue(site.getTerm(), forKey: site.getId())
            }
            let sectionList = Term.splitByTerms(listToSort: siteList)
            
            completion(sectionList)
        }
    }
    
    func getSiteGrades(siteId:String, completion: @escaping (_ grades: [[GradeItem]]?) -> Void) {
        let url:String = AppGlobals.SITE_GRADEBOOK_URL.replacingOccurrences(of: "*", with: siteId)
        self.makeRequest(url: url, method: .get) { response in
            guard let data = response.result.value else {
                print("error")
                return
            }
            
            var gradeList:[GradeItem] = [GradeItem]()
            guard let gradesJSON = JSON(data)["assignments"].array else {
                completion(nil)
                return
            }
            
            for gradeJSON in gradesJSON {
                gradeList.append(GradeItem(data: gradeJSON, siteId: siteId))
            }
            
            let grades = Term.splitByTerms(listToSort: gradeList)
            
            completion(grades)
        }
    }
    
    func getAllGrades(completion: @escaping (_ grades: [[GradeItem]]?) -> Void) {
        let url:String = AppGlobals.GRADEBOOK_URL
        self.makeRequest(url: url, method: .get) { response in
            guard let data = response.result.value else {
                print("error")
                return
            }
            
            guard let collection = JSON(data)["gradebook_collection"].array else {
                completion(nil)
                return
            }
            
            var gradeList:[GradeItem] = [GradeItem]()
            
            for site in collection {
                guard let assignments = site["assignments"].array else {
                    completion(nil)
                    return
                }
                let siteId:String = site["siteId"].string!
                for assignment in assignments {
                    gradeList.append(GradeItem(data: assignment, siteId: siteId))
                }
                
            }
            
            let grades = Term.splitByTerms(listToSort: gradeList)
            
            completion(grades)
        }
    }
}

extension Alamofire.SessionManager {
    
    /**
     
    Makes Alamofire request without caching any cookies, headers, or results
     
    */
    @discardableResult
    open func requestWithoutCache(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)// also you can add URLRequest.CachePolicy here as parameter
        -> DataRequest
    {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            // TODO: find a better way to handle error
            print(error)
            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
        }
    }
}
