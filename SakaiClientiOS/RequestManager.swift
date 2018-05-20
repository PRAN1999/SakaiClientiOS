//
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/25/18.
//

import Foundation
import Alamofire
import SwiftyJSON

class RequestManager {
    
    static let shared = RequestManager()
    
    private init() {
        
    }
    
    private func makeRequest(url:String, method: HTTPMethod, completion: @escaping (_ response:DataResponse<Any>) -> Void) {
        Alamofire.SessionManager.default.requestWithoutCache(url, method: method).validate().responseJSON { response in
            completion(response)
        }
    }
    
    func addCookie(cookie:HTTPCookie) {
        Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.setCookie(cookie)
    }
    
    func addHeader(value: Any, key: AnyHashable){
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders?.updateValue(value, forKey: key)
    }
    
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
    
    func isLoggedIn(completion: @escaping (Bool) -> Void)  {
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
            let sectionList = Site.splitByTerms(siteList: siteList)
            
            completion(sectionList)
        }
    }
    
    func getSiteGrades(siteId:String, completion: @escaping ([[GradeItem]]?) -> Void) {
        let url:String = AppGlobals.SITE_GRADEBOOK_URL.replacingOccurrences(of: "*", with: siteId)
        self.makeRequest(url: url, method: .get) { response in
            
        }
    }
    
    func getAllGrades(completion: @escaping () -> Void) {
        let url:String = AppGlobals.GRADEBOOK_URL
        self.makeRequest(url: url, method: .get) { response in
            
        }
    }
}

extension Alamofire.SessionManager {
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
