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

    private let loginUrl: String
    private let loginService: LoginService

    init(loginUrl: String, loginService: LoginService, downloadService: DownloadService, webService: WebService) {
        self.loginUrl = loginUrl
        self.loginService = loginService
        super.init(downloadService: downloadService, webService: webService)
    }

    convenience init(loginUrl: String) {
        self.init(loginUrl: loginUrl,
                  loginService: RequestManager.shared,
                  downloadService: RequestManager.shared,
                  webService: RequestManager.shared)
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
        allowsOptions = false
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// Captures HTTP Cookies from specific URLs and loads them into Login
    /// service Session. Allows all future requests to be authenticated.
    override func webView(_ webView: WKWebView,
                          decidePolicyFor navigationAction: WKNavigationAction,
                          decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let group = DispatchGroup()
        group.notify(queue: .main) {
            decisionHandler(.allow)
        }
        group.enter()
        if webView.url!.absoluteString == LoginConfiguration.cookieUrl {
            let store = webView.configuration.websiteDataStore.httpCookieStore
            store.getAllCookies { [weak self] cookies in
                for cookie in cookies {
                    HTTPCookieStorage.shared.setCookie(cookie as HTTPCookie)
                    self?.loginService.addCookie(cookie: cookie)
                }
                group.leave()
            }
        } else {
            group.leave()
        }
    }

    override func webView(_ webView: WKWebView,
                          decidePolicyFor navigationResponse: WKNavigationResponse,
                          decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if webView.url!.absoluteString == LoginConfiguration.cookieUrl {
            decisionHandler(.cancel)
            // If navigation request is to the redirect URL for a
            // successful login, the user should have successfully
            // authenticated. Validate the login and execute
            // onLogin callback. Also save authentication cookies. If login
            // validation fails, the webview is reloaded to try again.
            loginService.validateLoggedInStatus(
                onSuccess: { [weak self] in
                    self?.onLogin?()
                    UserDefaults.standard.set(self?.loginService.cookieArray, forKey: RequestManager.savedCookiesKey)
                },
                onFailure: { [weak self] err in
                    let store = self?.webView.configuration.websiteDataStore.httpCookieStore
                    store?.getAllCookies({ cookies in
                        cookies.forEach { cookie in
                            store?.delete(cookie, completionHandler: nil)
                        }
                    })
                    self?.loginService.clearCookies()
                    self?.loadWebview()
                }
            )
        } else {
            decisionHandler(.allow)
        }
    }
}
