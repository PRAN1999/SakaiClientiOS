//
//  LoginViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/14/18.
//

import UIKit
import WebKit
import ReusableSource

/// A view controller allowing users to login to CAS and/or Sakai
class LoginWebViewController: WebController {

    /// Callback to execute once user has been authenticated
    var onLogin: (() -> Void)?

    let loginUrl: String

    init(loginUrl: String) {
        self.loginUrl = loginUrl
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    /// Loads Login URL for CAS Authentication
    override func viewDidLoad() {
        RequestManager.shared.resetCache()
        setURL(url: URL(string: loginUrl))
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// Captures HTTP Cookies from specific URLs and loads them into Request Manager Session
    /// Allows all future requests to be authenticated.
    override func webView(_ webView: WKWebView,
                          decidePolicyFor navigationAction: WKNavigationAction,
                          decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let group = DispatchGroup()
        group.notify(queue: .main) {
            decisionHandler(.allow)
        }
        group.enter()
        if webView.url!.absoluteString == AppGlobals.cookieUrl {
            let store = webView.configuration.websiteDataStore.httpCookieStore
            store.getAllCookies { cookies in
                for cookie in cookies {
                    HTTPCookieStorage.shared.setCookie(cookie as HTTPCookie)
                    RequestManager.shared.addCookie(cookie: cookie)
                }
                group.leave()
            }
        } else {
            group.leave()
        }
    }

    /// Captures all HTTP headers and loads them into Request Manager Session, for request authentication.
    /// Stops webview navigation and executes onLogin callback once user is authenticated
    override func webView(_ webView: WKWebView,
                          decidePolicyFor navigationResponse: WKNavigationResponse,
                          decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if webView.url!.absoluteString == AppGlobals.cookieUrl {
            decisionHandler(.cancel)
            SakaiService.shared.validateLoggedInStatus(
                onSuccess: { [weak self] in
                    self?.onLogin?()
                    UserDefaults.standard.set(RequestManager.shared.cookieArray, forKey: RequestManager.savedCookiesKey)
                },
                onFailure: { [weak self] err in
                    let store = self?.webView.configuration.websiteDataStore.httpCookieStore
                    store?.getAllCookies({ cookies in
                        cookies.forEach { cookie in
                            store?.delete(cookie, completionHandler: nil)
                        }
                    })
                    RequestManager.shared.clearCookies()
                    self?.loadWebview()
                }
            )
        } else {
            decisionHandler(.allow)
        }
    }
}
