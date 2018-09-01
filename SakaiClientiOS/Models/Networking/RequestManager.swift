import Foundation
import Alamofire
import WebKit

/// A singleton instance around an Alamofire Session to manage all HTTP requests made by the app by
/// ensuring the user is logged in with every request.
///
/// Provides app-wide mechanism for logging use out and manages process pool for internal WebViews
/// - Author: Pranay Neelagiri
class RequestManager {

    /// The singleton RequestManager instance to be used across the app
    static let shared = RequestManager()

    /// The process pool to be shared by all WKWebView's opened in app.
    ///
    /// This shares cookies and headers needed for Sakai Authentication
    var processPool = WKProcessPool()

    /// Force the RequestManager to be a singleton
    private init() {}

    func makeRequest(url: String,
                     method: HTTPMethod,
                     parameters: Parameters? = nil,
                     completion: @escaping (_ data: Data?,
                                            _ err: SakaiError?) -> Void) {
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

    func makeRequestWithoutCache(url: String,
                                method: HTTPMethod,
                                parameters: Parameters? = nil,
                                completion: @escaping (_ data: Data?,
                                                       _ err: SakaiError?) -> Void) {
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

    /// Adds HTTP header to Alamofire Session
    ///
    /// - Parameters:
    ///   - value: The HTTP header value for the key
    ///   - key: The HTTP header name to add to Alamofire
    func addHeader(value: Any, key: AnyHashable) {
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders?.updateValue(value, forKey: key)
    }

    /// Ends Sakai session by resetting Alamofire Session and uses main thread to reroute app control to
    /// LoginViewController.
    func logout() {
        reset()
        let loginController = LoginViewController()
        let rootController = UIApplication.shared.keyWindow?.rootViewController
        loginController.onLogin = {
            rootController?.dismiss(animated: true, completion: nil)
        }
        let navController = WebViewNavigationController(rootViewController: loginController)
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
        // Clear URLcache to ensure no responses can be returned without authentication
        resetCache()
        // Flush all HTTP cookies
        let cookies: [HTTPCookie]! = Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.cookies
        for cookie in cookies {
            Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.deleteCookie(cookie)
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
        // Flush all HTTP headers
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
