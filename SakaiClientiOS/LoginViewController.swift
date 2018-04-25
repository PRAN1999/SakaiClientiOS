
import UIKit
import WebKit
import Alamofire
import MaterialComponents.MaterialAppBar

class LoginViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    let appBar = MDCAppBar()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.addChildViewController(appBar.headerViewController)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self;
        view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appBar.headerViewController.headerView.backgroundColor = UIColor(red: 1.0, green: 0.1, blue: 0.1, alpha: 1.0)
        appBar.navigationBar.tintColor = UIColor.black
        
        appBar.headerViewController.view.frame = view.bounds
        view.addSubview(appBar.headerViewController.view)
        
        appBar.headerViewController.didMove(toParentViewController: self)
        
        appBar.addSubviewsToParent()
        appBar.navigationBar.observe(navigationItem)
        
        title = "Login"
        
        let myURL = URL(string: "https://cas.rutgers.edu/login?service=https%3A%2F%2Fsakai.rutgers.edu%2Fsakai-login-tool%2Fcontainer")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                }
            }
        } else if (webView.url!.absoluteString == "https://sakai.rutgers.edu/portal") {
            let store = WKWebsiteDataStore.default().httpCookieStore
            store.getAllCookies { (cookies) in
                for cookie in cookies {
                    HTTPCookieStorage.shared.setCookie(cookie as HTTPCookie)
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
            navigationController?.popToRootViewController(animated: true)
            return
        }
        decisionHandler(.allow)
    }

}
