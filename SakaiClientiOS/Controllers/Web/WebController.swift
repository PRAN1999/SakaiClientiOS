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
    var needsNav: Bool = true
    
    var backButton: UIBarButtonItem?
    var forwardButton: UIBarButtonItem?
    var flexButton: UIBarButtonItem?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    /// Sets the webview delegates for navigation and UI to the view controller itself, allowing the view controller to directly control the webview appearance and requests
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = RequestManager.shared.processPool
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view = webView
    }
    
    deinit {
        guard webView != nil else {
            return
        }
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.allowsBackForwardNavigationGestures = true
        setupProgressBar()
        if needsNav {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pop))
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadWebview))
        } else {
            self.navigationController?.isNavigationBarHidden = true
        }
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldLoad {
            loadURL(urlOpt: url)
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupToolbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.isMovingFromParentViewController) {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    func setupProgressBar() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.tintColor = AppGlobals.SAKAI_RED
        navigationController?.navigationBar.addSubview(progressView)
        guard let navigationBarBounds = self.navigationController?.navigationBar.bounds else {
            return
        }
        progressView.frame = CGRect(x: 0, y: navigationBarBounds.size.height - 2, width: navigationBarBounds.size.width, height: 8)
    }
    
    func setupToolbar() {
        let backButtonImage = UIImage(named: "back_button")
        let forwardButtonImage = UIImage(named: "forward_button")
        flexButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(goBack))
        forwardButton = UIBarButtonItem(image: forwardButtonImage, style: .plain,target: self, action: #selector(goForward))
        
        let arr = [backButton!, flexButton!, flexButton!, forwardButton!]
        
        self.navigationController?.toolbar.setItems(arr, animated: true)
        self.navigationController?.toolbar.barTintColor = UIColor.black
        self.navigationController?.toolbar.tintColor = AppGlobals.SAKAI_RED
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
    
    @objc func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc func loadWebview() {
        loadURL(urlOpt: url)
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func canRotate() -> Void {}
}

extension WebController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        self.url = navigationResponse.response.url
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.progressView.isHidden = true
        }
        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';")
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
