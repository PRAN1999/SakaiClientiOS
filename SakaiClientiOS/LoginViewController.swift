
import UIKit
import WebKit
import Alamofire

class LoginViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    
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
        let myURL = URL(string: "https://cas.rutgers.edu/login?service=https%3A%2F%2Fsakai.rutgers.edu%2Fsakai-login-tool%2Fcontainer")
        let myRequest = URLRequest(url: myURL!)
        self.webView.load(myRequest)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.url!.absoluteString)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(webView.url!.absoluteString)
        
        if(webView.url!.absoluteString == "https://sakai.rutgers.edu/sakai-login-tool/container") {
            let store = WKWebsiteDataStore.default().httpCookieStore
            store.getAllCookies { (cookies) in
                for cookie in cookies {
                    HTTPCookieStorage.shared.setCookie(cookie as HTTPCookie)
                    Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.setCookie(cookie)
                }
            }
        } else if (webView.url!.absoluteString == "https://sakai.rutgers.edu/portal") {
            let store = WKWebsiteDataStore.default().httpCookieStore
            store.getAllCookies { (cookies) in
                for cookie in cookies {
                    HTTPCookieStorage.shared.setCookie(cookie as HTTPCookie)
                    Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.setCookie(cookie)
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
            Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders?.updateValue(header.value, forKey: header.key)
        }
        if(webView.url!.absoluteString == "https://sakai.rutgers.edu/portal") {
            decisionHandler(.cancel)
            self.performSegue(withIdentifier: "loginSegue", sender: self)
            return
        }
        decisionHandler(.allow)
    }

}
