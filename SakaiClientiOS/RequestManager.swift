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

class RequestManager {
    
    class func isLoggedIn(completion: @escaping (Bool) -> Void)  {
        Alamofire.SessionManager.default.requestWithoutCache("https://sakai.rutgers.edu/direct/session/current.json", method: .get).validate().responseJSON { response in
            var flag = false
            if let data = response.result.value {
                print("JSON: \(data)")
                let json = JSON(data)
                if json["userEid"].string != nil {
                    print("Flag set to true")
                    flag = true
                } else {
                    reset()
                    print("Flag is false")
                }
            }
            completion(flag)
        }
    }
    
    class func makeReq() {
        let cookies:[HTTPCookie]! = HTTPCookieStorage.shared.cookies
        for cookie in cookies {
            Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.setCookie(cookie)
        }
        
        Alamofire.SessionManager.default.requestWithoutCache("https://sakai.rutgers.edu/direct/session/current.json", method: .get).validate().responseJSON { response in
            
            if let json = response.result.value {
                print("JSON: \(json)")
            }
        }
    }
    
    class func logout() {
        Alamofire.SessionManager.default.session.configuration.urlCache = nil
        let cookies:[HTTPCookie]! = Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.cookies
        for cookie in cookies {
            Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.deleteCookie(cookie)
        }
    }
    
    class func reset() {
        URLCache.shared.removeAllCachedResponses()
        Alamofire.SessionManager.default.session.configuration.urlCache = nil
        let cookies:[HTTPCookie]! = Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.cookies
        for cookie in cookies {
            Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.deleteCookie(cookie)
        }
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders?.removeValue(forKey: AnyHashable("X-Sakai-Session"))
    }
    
}

extension Alamofire.SessionManager{
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
