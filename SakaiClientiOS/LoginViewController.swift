
import UIKit
import WebKit

class LoginViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self;
        view = webView
    }
    
    override func viewDidLoad() {
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(webView.url!.absoluteString)
        
        if webView.url!.absoluteString == AppGlobals.COOKIE_URL_1 || webView.url!.absoluteString == AppGlobals.COOKIE_URL_2 {
            let store = WKWebsiteDataStore.default().httpCookieStore
            store.getAllCookies { (cookies) in
                for cookie in cookies {
                    print(cookie)
                    HTTPCookieStorage.shared.setCookie(cookie as HTTPCookie)
                    RequestManager.shared.addCookie(cookie: cookie)
                }
            }
        }
        decisionHandler(.allow)
        return
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("Setting Headers")
        let response = navigationResponse.response as? HTTPURLResponse
        let headers = response!.allHeaderFields
        for header in headers {
            RequestManager.shared.addHeader(value: header.value, key: header.key)
        }
        if(webView.url!.absoluteString == AppGlobals.COOKIE_URL_2) {
            decisionHandler(.cancel)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabController:UITabBarController = storyboard.instantiateViewController(withIdentifier: "tabs") as! UITabBarController
            self.present(tabController, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "loginSegue", sender: self)
            return
        }
        decisionHandler(.allow)
    }
}
