import Foundation
import Alamofire
import SwiftyJSON
import WebKit

/**
 
 A singleton instance around an Alamofire Session to manage all HTTP requests made by the app by ensuring the user is logged in with every request. Provides app-wide mechanism for logging use out and manages process pool for internal WebViews
 
 - author: Pranay Neelagiri
 
 */

class RequestManager {
    
    /**
 
    The singleton RequestManager instance to be used across the app
     
     */
    static let shared = RequestManager()
    
    ///The process pool to be shared by all WKWebView's opened in app.
    ///
    ///This shares cookies and headers needed for Sakai Authentication
    var processPool = WKProcessPool()
    
    ///A flag indicating whether the user is logged in; Unused for now
    var loggedIn = false
    
    ///A flag indicating whether data needs to be reloaded in HomeController; Unused for now
    var toReload = true
    
    ///Force the RequestManager to be a singleton
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
    func makeRequest(url:String, method: HTTPMethod, completion: @escaping (_ response:DataResponse<Any>) -> Void) {
        //Check if user is logged in before making request, and initiate logout procedure if they aren't
        self.isLoggedIn { (flag) in
            if(!flag) {
                self.logout {}
            } else {
                Alamofire.SessionManager.default.request(url, method: method).validate().responseJSON { response in
                    completion(response)
                }
            }
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
    
    
    /// Ends Sakai session by resetting Alamofire Session and uses main thread to reroute app control to LoginViewController.
    ///
    /// - Parameter completion: A callback to execute once user has been logged out
    func logout(completion: @escaping () -> Void) {
        
        reset()
        toReload = true
        loggedIn = false
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            //Dismiss tab bar controller, and then reinstantiate initial view controller for login
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: {
                UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
                completion()
            })
        })
    }
    
    
    /// Resets URL cache for Alamofire session to force new data requests
    func resetCache() {
        URLCache.shared.removeAllCachedResponses()
        Alamofire.SessionManager.default.session.configuration.urlCache?.removeAllCachedResponses()
    }
    
    /**
     
     Resets Alamofire session by flushing session configuration of all Cookies and Headers. Also resets WKProcessPool, siteTitleMap, and siteTermMap
     
    */
    func reset() {
        
        //Clear URLcache to ensure no responses can be returned without authentication
        resetCache()
        
        //Flush all HTTP cookies
        let cookies:[HTTPCookie]! = Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.cookies
        for cookie in cookies {
            Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.deleteCookie(cookie)
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
        
        //Flush all HTTP headers
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders?.removeValue(forKey: AnyHashable("X-Sakai-Session"))
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders?.removeAll()
        DataHandler.shared.reset()
        processPool = WKProcessPool()
    }
    
    /**
     
     Makes an HTTP request to determine if user is logged in. Sakai server returns valid response whether or not user is logged in, so result of check is passed into callback
     
     - parameters:
        - completion: A completion handler that is called with a Boolean result of whether the user is logged in or not
        - check: Boolean flag determining if user is logged in, passed into closure - acted on by callee
     
     */
    func isLoggedIn(completion: @escaping (_ check:Bool) -> Void)  {
        Alamofire.SessionManager.default.requestWithoutCache(AppGlobals.SESSION_URL, method: .get).validate().responseJSON { response in
            var flag = false
            if let data = response.result.value {
                let json = JSON(data)
                print("json: \(json)")
                if json["userEid"].string != nil { //If the userEid field is not null, the user's session is active and they are logged in
                    print("Flag set to true")
                    flag = true
                } else {
                    //self.reset()
                    print("Flag is false")
                }
            }
            completion(flag)
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
