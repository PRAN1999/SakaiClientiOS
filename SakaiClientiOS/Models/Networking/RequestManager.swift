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

    static let savedCookiesKey = "savedCookies"
    private let portalURL = URL(string: "https://sakai.rutgers.edu/portal")

    private var _processPool = WKProcessPool()
    private var _userId: String?
    private var _cookieArray: [[HTTPCookiePropertyKey: Any]] = []

    private var session: URLSession {
        return Alamofire.SessionManager.default.session
    }

    private init() {}

    private func makeRequest(url: String, method: HTTPMethod, parameters: Parameters? = nil,
                     completion: @escaping (_ data: Data?, _ err: SakaiError?) -> Void) {
        Alamofire.SessionManager.default
            .request(url, method: method, parameters: parameters).validate().responseJSON { response in
                if let error = response.error {
                    completion(nil, SakaiError.networkError(error.localizedDescription, response.response?.statusCode))
                    return
                }
                guard let data = response.data else {
                    completion(nil, SakaiError.parseError("Server failed to return any data"))
                    return
                }
                completion(data, nil)
        }
    }

    private func makeRequestWithoutCache(url: String, method: HTTPMethod, parameters: Parameters? = nil,
                                 completion: @escaping (_ data: Data?, _ err: SakaiError?) -> Void) {
        Alamofire.SessionManager.default.requestWithoutCache(url, method: .get).validate()
            .responseJSON { response in
                if let error = response.error  {
                    completion(nil, SakaiError.networkError(error.localizedDescription, response.response?.statusCode))
                    return
                }
                guard let data = response.data else {
                    completion(nil, SakaiError.parseError("Server failed to return any data"))
                    return
                }
                completion(data, nil)
        }
    }

    func resetCache() {
        URLCache.shared.removeAllCachedResponses()
        session.configuration.urlCache?.removeAllCachedResponses()
    }

    func reset() {
        resetCache()
        _processPool = WKProcessPool()
        _userId = nil
        clearCookies()
    }

    func refreshCookies() {
        if let url = portalURL {
            Alamofire.SessionManager.default.request(url).response(queue: DispatchQueue.global(qos: .background)) { [weak self] res in
                self?.loadCookiesIntoUserDefaults()
            }
        }
    }
}

extension RequestManager: NetworkService {
    func makeEndpointRequest<T: Decodable>(request: SakaiRequest<T>, completion: @escaping (T?, SakaiError?) -> Void) {
        let url = request.endpoint.getEndpoint()
        let method = request.method
        makeRequest(url: url, method: method, parameters: request.parameters) { data, err in
            guard err == nil, let data = data else {
                completion(nil, err)
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970

            do {
                let decoded = try decoder.decode(T.self, from: data)
                completion(decoded, nil)
            } catch let error {
                completion(nil, SakaiError.parseError(error.localizedDescription))
            }
        }
    }

    func makeEndpointRequestWithoutCache<T: Decodable>(request: SakaiRequest<T>, completion: @escaping (T?, SakaiError?) -> Void) {
        let url = request.endpoint.getEndpoint()
        let method = request.method
        makeRequestWithoutCache(url: url, method: method, parameters: request.parameters) { data, err in
            guard err == nil, let data = data else {
                completion(nil, err)
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970

            do {
                let decoded = try decoder.decode(T.self, from: data)
                completion(decoded, nil)
            } catch let error {
                completion(nil, SakaiError.parseError(error.localizedDescription))
            }
        }
    }
}

extension RequestManager: LoginService {

    var userId: String? {
        return _userId
    }

    var cookieArray: [[HTTPCookiePropertyKey : Any]] {
        return _cookieArray
    }

    func loadCookiesFromUserDefaults() -> Bool {
        guard let cookieArray = UserDefaults.standard.array(forKey: RequestManager.savedCookiesKey) as? [[HTTPCookiePropertyKey: Any]] else { return false }
        for properties in cookieArray {
            guard let cookie = HTTPCookie(properties: properties) else {
                continue
            }
            HTTPCookieStorage.shared.setCookie(cookie)
            addCookie(cookie: cookie)
        }
        return true
    }

    func loadCookiesIntoUserDefaults() {
        guard let cookies = session.configuration.httpCookieStorage?.cookies else {
            return
        }
        var arr: [[HTTPCookiePropertyKey: Any]] = []
        for cookie in cookies {
            if let props = cookie.properties {
                arr.append(props)
            }
        }
        UserDefaults.standard.set(arr, forKey: RequestManager.savedCookiesKey)
    }

    func addCookie(cookie: HTTPCookie) {
        session.configuration.httpCookieStorage?.setCookie(cookie)
        if let properties = cookie.properties {
            _cookieArray.append(properties)
        }
    }

    func clearCookies() {
        guard let cookies = session.configuration.httpCookieStorage?.cookies else {
            return
        }
        for cookie in cookies {
            session.configuration.httpCookieStorage?.deleteCookie(cookie)
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
        _cookieArray = []
        UserDefaults.standard.set(nil, forKey: RequestManager.savedCookiesKey)
    }

    func validateLoggedInStatus(onSuccess: @escaping () -> Void, onFailure: @escaping (SakaiError?) -> Void) {
        let url = SakaiEndpoint.session.getEndpoint()
        makeRequestWithoutCache(url: url, method: .get) { [weak self] (data, err) in
            let decoder = JSONDecoder()
            guard let data = data else {
                onFailure(err)
                return
            }
            do {
                let session = try decoder.decode(UserSession.self, from: data)
                self?._userId = session.userEid
                onSuccess()
            } catch let decodingError {
                onFailure(SakaiError.parseError(decodingError.localizedDescription))
            }
        }
    }
}

extension RequestManager: DownloadService {
    func downloadToDocuments(url: URL, completion: @escaping (_ fileDestination: URL?) -> Void) {
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        Alamofire.download(URLRequest(url: url), to: destination).response(queue: DispatchQueue.global(qos: .utility)) { res in
            DispatchQueue.main.async {
                completion(res.destinationURL)
            }
        }
    }
}

extension RequestManager: WebService {

    var processPool: WKProcessPool {
        return _processPool
    }

    var cookies: [HTTPCookie]? {
        return session.configuration.httpCookieStorage?.cookies
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
