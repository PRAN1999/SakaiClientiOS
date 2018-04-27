//
//  File.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/25/18.
//  Copyright © 2018 MAGNUMIUM. All rights reserved.
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
    
    static var BASE_URL = "https://sakai.rutgers.edu/direct/"
    
    static var SITES_URL = BASE_URL + "site.json"
    static var SESSION_URL = BASE_URL + "session/current.json"
    static var USER_URL = BASE_URL + "user/current.json"
    
    class func isLoggedIn(completion: @escaping (Bool) -> Void)  {
        Alamofire.SessionManager.default.requestWithoutCache(SESSION_URL, method: .get).validate().responseJSON { response in
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
    
    class func logout() {
        URLCache.shared.removeAllCachedResponses()
        Alamofire.SessionManager.default.session.configuration.urlCache = nil
        let cookies:[HTTPCookie]! = Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.cookies
        for cookie in cookies {
            Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.deleteCookie(cookie)
        }
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders?.removeValue(forKey: AnyHashable("X-Sakai-Session"))
    }
    
    class func getSites(completion: @escaping (_ site: [Site]?) -> Void) {
        Alamofire.SessionManager.default.requestWithoutCache(SITES_URL, method: .get).validate().responseJSON {response in
            guard let data = response.result.value else {
                print("error")
                return
            }
            
            var siteList:[Site] = [Site]()
            let sitesJSON = JSON(data)["site_collection"].array!
            
            for siteJSON in sitesJSON {
                let id:String? = siteJSON["id"].string
                let title:String? = siteJSON["title"].string
                let description:String? = siteJSON["htmlDescription"].string
                let site:Site! = Site(id: id, title: title, description: description)
                siteList.append(site)
            }
            completion(siteList)
        }
    }
    
}
