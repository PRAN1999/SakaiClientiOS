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

    init(url: String) {
        self.loginUrl = url
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// Captures HTTP Cookies from specific URLs and loads them into Request Manager Session,
    /// allowing all future requests to be authenticated.
    override func webView(_ webView: WKWebView,
                          decidePolicyFor navigationAction: WKNavigationAction,
                          decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if webView.url!.absoluteString == AppGlobals.cookieUrl1 ||
            webView.url!.absoluteString == AppGlobals.cookieUrl2 {
            let store = WKWebsiteDataStore.default().httpCookieStore
            store.getAllCookies { (cookies) in
                for cookie in cookies {
                    HTTPCookieStorage.shared.setCookie(cookie as HTTPCookie)
                    RequestManager.shared.addCookie(cookie: cookie)
                }
            }
        }
        decisionHandler(.allow)
        return
    }

    /// Captures all HTTP headers and loads them into Request Manager Session, for request authentication.
    /// Stops webview navigation and executes onLogin callback once user is authenticated
    override func webView(_ webView: WKWebView,
                          decidePolicyFor navigationResponse: WKNavigationResponse,
                          decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if webView.url!.absoluteString == AppGlobals.cookieUrl2 {
            decisionHandler(.cancel)
            SakaiService.shared.validateLoggedInStatus(
                onSuccess: { [weak self] in
                    self?.onLogin?()
                },
                onFailure: { [weak self] err in
                    self?.loadWebview()
                })
        } else {
            decisionHandler(.allow)
        }
    }
}
