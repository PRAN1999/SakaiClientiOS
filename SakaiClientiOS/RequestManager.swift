//
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/25/18.
//

import Foundation
import Alamofire
import SwiftyJSON

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

class RequestManager {
    
    static var LOGIN_URL = "https://cas.rutgers.edu/login?service=https%3A%2F%2Fsakai.rutgers.edu%2Fsakai-login-tool%2Fcontainer"
    static var COOKIE_URL_1 = "https://sakai.rutgers.edu/sakai-login-tool/container"
    static var COOKIE_URL_2 = "https://sakai.rutgers.edu/portal"
    
    static var BASE_URL:String = "https://sakai.rutgers.edu/direct/"
    
    static var SITES_URL:String = BASE_URL + "site.json"
    static var SESSION_URL:String = BASE_URL + "session/current.json"
    static var USER_URL:String = BASE_URL + "user/current.json"
    
    private class func makeRequest(url:String, method: HTTPMethod, completion: @escaping (_ response:DataResponse<Any>) -> Void) {
        Alamofire.SessionManager.default.requestWithoutCache(url, method: method).validate().responseJSON { response in
            completion(response)
        }
    }
    
    class func addCookie(cookie:HTTPCookie) {
        Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.setCookie(cookie)
    }
    
    class func addHeader(value: Any, key: AnyHashable){
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders?.updateValue(value, forKey: key)
    }
    
    class func logout() {
        URLCache.shared.removeAllCachedResponses()
        Alamofire.SessionManager.default.session.configuration.urlCache = nil
        let cookies:[HTTPCookie]! = Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.cookies
        for cookie in cookies {
            Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.deleteCookie(cookie)
        }
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders?.removeValue(forKey: AnyHashable("X-Sakai-Session"))
    }
    
    class func isLoggedIn(completion: @escaping (Bool) -> Void)  {
        self.makeRequest(url: SESSION_URL, method: .get) { response in
            var flag = false
            if let data = response.result.value {
                print("JSON: \(data)")
                let json = JSON(data)
                if json["userEid"].string != nil {
                    print("Flag set to true")
                    flag = true
                } else {
                    logout()
                    print("Flag is false")
                }
            }
            completion(flag)
        }
    }
    
    class func getSites(completion: @escaping (_ site: [[Site]]?) -> Void) {
         self.makeRequest(url: SITES_URL, method: .get) { response in
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
            }
            let sectionList = Site.splitByTerms(siteList: siteList)
            
            completion(sectionList)
        }
    }
}
