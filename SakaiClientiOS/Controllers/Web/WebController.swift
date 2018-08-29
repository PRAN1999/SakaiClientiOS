//
//  WebController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit
import WebKit
import Alamofire

class WebController: UIViewController {

    var webView: WKWebView!
    var progressView: UIProgressView!
    
    var backButton: UIBarButtonItem!
    var forwardButton: UIBarButtonItem!
    var interactionButton: UIBarButtonItem!
    var flexButton: UIBarButtonItem!
    
    var actionController: UIAlertController!
    var interactionController: UIDocumentInteractionController!
    
    var url:URL?
    var shouldLoad: Bool = true
    var needsNav: Bool = true
    
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
        setupProgressBar()
        setupNavBar()
        setupToolbar()
        setupActionSheet()
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        self.navigationController?.toolbar.tintColor = AppGlobals.SAKAI_RED
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    private func setupNavBar() {
        if needsNav {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pop))
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadWebview))
        } else {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    private func setupProgressBar() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.tintColor = AppGlobals.SAKAI_RED
        navigationController?.navigationBar.addSubview(progressView)
        guard let navigationBarBounds = self.navigationController?.navigationBar.bounds else {
            return
        }
        progressView.frame = CGRect(x: 0, y: navigationBarBounds.size.height - 2, width: navigationBarBounds.size.width, height: 8)
    }
    
    private func setupToolbar() {
        let backButtonImage = UIImage(named: "back_button")
        let forwardButtonImage = UIImage(named: "forward_button")
        flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(goBack))
        interactionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(presentDownloadOption))
        forwardButton = UIBarButtonItem(image: forwardButtonImage, style: .plain,target: self, action: #selector(goForward))
        
        let arr: [UIBarButtonItem] = [backButton, flexButton, interactionButton, flexButton, forwardButton]
        
        self.setToolbarItems(arr, animated: true)
    }
    
    private func setupActionSheet() {
        let downloadAction = UIAlertAction(title: "Download", style: .default) { (action) in
            self.downloadAndPresentInteractionController()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionController.addAction(downloadAction)
        actionController.addAction(cancelAction)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldLoad {
            loadURL(urlOpt: url)
        }
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.isMovingFromParentViewController) {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
        self.navigationController?.setToolbarHidden(true, animated: true)
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
    
    func downloadAndPresentInteractionController() {
        guard let url = url else {
            return
        }
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        interactionButton.isEnabled = false
        Alamofire.download(URLRequest(url: url), to: destination).response { [weak self] (res) in
            guard let fileUrl = res.destinationURL else {
                return
            }
            guard let button = self?.interactionButton else {
                return
            }
            print(fileUrl)
            self?.interactionController = UIDocumentInteractionController(url: fileUrl)
            DispatchQueue.main.async {
                self?.interactionController.presentOpenInMenu(from: button, animated: true)
                self?.interactionButton.isEnabled = true
            }
        }
    }
}

extension WebController {
    @objc private func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc private func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc private func loadWebview() {
        loadURL(urlOpt: url)
    }
    
    @objc private func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func presentDownloadOption() {
        self.present(actionController, animated: true, completion: nil)
    }
    
    @objc func canRotate() -> Void {}
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
        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';")
        webView.evaluateJavaScript("$('.Mrphs-topHeader').remove();$('.Mrphs-siteHierarchy').remove();$('#toolMenuWrap').remove();$('#skipNav').remove();var selectedElement = document.querySelector('#content');document.body.innerHTML = selectedElement.innerHTML;")
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
