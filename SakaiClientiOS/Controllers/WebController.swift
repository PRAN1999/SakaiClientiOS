//
//  WebController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit
import WebKit

class WebController: UIViewController {

    var webView: WKWebView!
    var progressView: UIProgressView!
    var url:URL?
    var shouldLoad: Bool = true
    var needsToolbar: Bool = true
    
    /**
     
     Sets the webview delegates for navigation and UI to the view controller itself,
     allowing the view controller to directly control the webview appearance and requests
     
     */
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = RequestManager.shared.processPool
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self;
        self.view = webView
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.tintColor = AppGlobals.SAKAI_RED
        navigationController?.navigationBar.addSubview(progressView)
        guard let navigationBarBounds = self.navigationController?.navigationBar.bounds else {
            return
        }
        progressView.frame = CGRect(x: 0, y: navigationBarBounds.size.height - 2, width: navigationBarBounds.size.width, height: 8)
    }
    
    deinit {
        //remove all observers
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        //remove progress bar from navigation bar
        progressView.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.allowsBackForwardNavigationGestures = true
        if needsToolbar {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pop))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadWebview))
            self.navigationController?.isNavigationBarHidden = false
        }
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if shouldLoad {
            loadURL(urlOpt: url)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        if (self.isMovingFromParentViewController) {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc func loadWebview() {
        loadURL(urlOpt: url)
    }
    
    func loadURL(urlOpt:URL?) {
        guard let url = urlOpt else {
            return
        }
        
        webView.load(URLRequest(url: url))
        shouldLoad = false
    }
    
    func setURL(url:URL) {
        self.url = url
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func canRotate() -> Void {
        
    }
}

extension WebController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.progressView.isHidden = true
        }
    }
}

class WebViewNavigationController: UINavigationController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        // fix webview input-file dismiss-twice bug
        if let _ = self.presentedViewController {
            super.dismiss(animated: flag, completion: completion)
        }
    }
}

extension UIViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let webController = WebController()
        webController.setURL(url: URL)
        
        self.navigationController?.pushViewController(webController, animated: true)
        
        return false
    }
}
