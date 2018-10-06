//
//  ResourceManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/1/18.
//

import Foundation
import Alamofire
import WebKit

/// A singleton instance around an Alamofire Session to manage all HTTP requests and WKWebView URL loads
/// made by the app by ensuring the user is logged in with every request.
class RequestManager {

    static let shared = RequestManager()

    /// The process pool to be shared by all WKWebView's opened in app.
    ///
    /// This shares cookies and headers needed for Sakai Authentication
    var processPool = WKProcessPool()

    var isLoggedIn = false

    private init() {}

    /// Executes and validates an HTTP request and passes any retrieved data and any errors into
    /// completion handler
    ///
    /// - Parameters:
    ///   - url: the URL to make a request to
    ///   - method: the HTTP request type (GET, POST, etc..)
    ///   - parameters: any parameters needed for the request (the body of a POST request)
    ///   - completion: a completion handler called with data and err
    ///   - data: the Data retrieved from the server, may be nil
    ///   - err: a SakaiError that wraps any network errors from the request
    func makeRequest(url: String, method: HTTPMethod, parameters: Parameters? = nil,
                     completion: @escaping (_ data: Data?, _ err: SakaiError?) -> Void) {
        Alamofire.SessionManager.default
            .request(url, method: method, parameters: parameters).validate().responseJSON { response in
                if let error = response.error {
                    completion(nil, SakaiError.networkError(error.localizedDescription))
                    return
                }
                guard let data = response.data else {
                    completion(nil, SakaiError.parseError("Server failed to return any data"))
                    return
                }
                completion(data, nil)
        }
    }

    /// Executes and validates an HTTP request without storing or caching any responses. See **makeRequest**
    func makeRequestWithoutCache(url: String, method: HTTPMethod, parameters: Parameters? = nil,
                                 completion: @escaping (_ data: Data?, _ err: SakaiError?) -> Void) {
        Alamofire.SessionManager.default.requestWithoutCache(url, method: .get).validate()
            .responseJSON { response in
                if let error = response.error {
                    completion(nil, SakaiError.networkError(error.localizedDescription))
                    return
                }
                guard let data = response.data else {
                    completion(nil, SakaiError.parseError("Server failed to return any data"))
                    return
                }
                completion(data, nil)
        }
    }

    /// Download the data at a remote URL to the Documents directory for the app, and callback with
    /// the location of the downloaded item
    ///
    /// - Parameters:
    ///   - url: the URL to download data from
    ///   - completion: a completion handler to call with the location of the downloaded file
    func downloadToDocuments(url: URL, completion: @escaping (_ fileDestination: URL?) -> Void) {
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        Alamofire.download(URLRequest(url: url), to: destination).response(queue: DispatchQueue.global(qos: .utility)) { res in
            DispatchQueue.main.async {
                completion(res.destinationURL)
            }
        }
    }

    /// Adds HTTP cookie to Alamofire Session
    ///
    /// - Parameter cookie: The HTTP cookie to add to the Alamofire Session
    func addCookie(cookie: HTTPCookie) {
        Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.setCookie(cookie)
    }

    /// Ends Sakai session by resetting Alamofire Session and uses main thread to reroute app control to
    /// LoginViewController.
    func logout() {
        reset()
        isLoggedIn = false
        let rootController = UIApplication.shared.keyWindow?.rootViewController
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        guard let navController = storyboard.instantiateViewController(withIdentifier: "loginNavigation") as? UINavigationController else {
            return
        }
        guard let loginController = navController.viewControllers.first as? LoginController else {
            return
        }
        loginController.onLogin = {
            DispatchQueue.main.async {
                rootController?.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ReloadActions.reloadHome.rawValue), object: nil, userInfo: nil)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            rootController?.present(navController, animated: true, completion: nil)
        })
    }

    /// Resets URL cache for Alamofire session to force new data requests
    func resetCache() {
        URLCache.shared.removeAllCachedResponses()
        Alamofire.SessionManager.default.session.configuration.urlCache?.removeAllCachedResponses()
    }

    /// Resets Alamofire session by flushing session configuration of all Cookies and Headers. Also resets
    /// WKProcessPool, siteTitleMap, and siteTermMap
    func reset() {
        resetCache()
        let cookies: [HTTPCookie]! = Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.cookies
        for cookie in cookies {
            Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.deleteCookie(cookie)
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders?
            .removeValue(forKey: AnyHashable("X-Sakai-Session"))
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders?.removeAll()
        SakaiService.shared.reset()
        processPool = WKProcessPool()
    }
}

extension Alamofire.SessionManager {

    /// Makes Alamofire request without caching any cookies, headers, or results
    @discardableResult
    open func requestWithoutCache(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)// also you can add URLRequest.CachePolicy here as parameter
        -> DataRequest {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            print(error)
            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
        }
    }
}
