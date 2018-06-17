
import UIKit
import WebKit

/**
 
 A view controller containing a webview allowing users to login to CAS and Sakai
 
 - Author:
 Pranay Neelagiri
 
 */

class LoginViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
 
    /**
     
     Sets the webview delegates for navigation and UI to the view controller itself,
     allowing the view controller to directly control the webview appearance and requests
     
     */
    
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = AppGlobals.PROCESS_POOL
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self;
        view = webView
    }
    
    /**
     
     Loads Login URL for CAS Authentication
     
     */
    override func viewDidLoad() {
        //view.addSubview(webView)
        RequestManager.shared.reset()
        super.viewDidLoad()
        let myURL = URL(string: AppGlobals.LOGIN_URL)
        let myRequest = URLRequest(url: myURL!)
        self.webView.load(myRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.url!.absoluteString)
    }
    
    /**
     
     Captures HTTP Cookies from specific URLs and loads them into Alamofire Session, allowing all future requests to be authenticated.
     
     */
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(webView.url!.absoluteString)
        
        if webView.url!.absoluteString == AppGlobals.COOKIE_URL_1 || webView.url!.absoluteString == AppGlobals.COOKIE_URL_2 {
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
    
    /*
     
     Captures all HTTP headers and loads them into Alamofire Session, for request authentication.
     Stops webview navigation and forces controller transition once target URL is reaches
     
     */
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("Setting Headers")
        let response = navigationResponse.response as? HTTPURLResponse
        let headers = response!.allHeaderFields
        for header in headers {
            RequestManager.shared.addHeader(value: header.value, key: header.key)
        }
        if(webView.url!.absoluteString == AppGlobals.COOKIE_URL_2) {
            decisionHandler(.cancel)
            RequestManager.shared.getSites() { res in
                AppGlobals.IS_LOGGED_IN = true
                AppGlobals.TO_RELOAD = false
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}
