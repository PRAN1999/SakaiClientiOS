import UIKit
import WebKit
import ReusableSource

///  A view controller containing a webview allowing users to login to CAS and Sakai
class LoginViewController: WebController {

    var onLogin: (() -> ())?

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    /// Loads Login URL for CAS Authentication
    override func viewDidLoad() {
        RequestManager.shared.resetCache()
        let url = URL(string: AppGlobals.loginUrl)
        setURL(url: url)
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// Captures HTTP Cookies from specific URLs and loads them into Alamofire Session, allowing all future requests to
    /// be authenticated.
    override func webView(_ webView: WKWebView,
                          decidePolicyFor navigationAction: WKNavigationAction,
                          decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if webView.url!.absoluteString == AppGlobals.cookieUrl1 ||
            webView.url!.absoluteString == AppGlobals.cookieUrl2 {
            let store = WKWebsiteDataStore.default().httpCookieStore
            store.getAllCookies { (cookies) in
                for cookie in cookies {
                    //print(cookie)
                    HTTPCookieStorage.shared.setCookie(cookie as HTTPCookie)
                    RequestManager.shared.addCookie(cookie: cookie)
                }
            }
        }
        decisionHandler(.allow)
        return
    }

    /// Captures all HTTP headers and loads them into Alamofire Session, for request authentication.
    /// Stops webview navigation and forces controller transition once target URL is reaches
    override func webView(_ webView: WKWebView,
                          decidePolicyFor navigationResponse: WKNavigationResponse,
                          decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let response = navigationResponse.response as? HTTPURLResponse
        let headers = response!.allHeaderFields
        for header in headers {
            RequestManager.shared.addHeader(value: header.value, key: header.key)
        }
        if webView.url!.absoluteString == AppGlobals.cookieUrl2 {
            decisionHandler(.cancel)
            onLogin?()
        } else {
            decisionHandler(.allow)
        }
    }
}
