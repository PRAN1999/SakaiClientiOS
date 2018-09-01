//
//  WebController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit
import WebKit

/// A WKWebView controller to display and navigate custom Sakai webpages and data.
///
/// Should be used across app to display any web page or content
class WebController: UIViewController {

    // MARK: Views

    private var webView: WKWebView!
    private var progressView: UIProgressView!

    // MARK: Navigation and toolbar items

    private var backButton: UIBarButtonItem!
    private var forwardButton: UIBarButtonItem!
    private var interactionButton: UIBarButtonItem!
    private var flexButton: UIBarButtonItem!

    // MARK: Custom view controllers

    private var actionController: UIAlertController!
    private var interactionController: UIDocumentInteractionController!

    // MARK: WKWebView configuration

    private var url: URL?

    var shouldLoad: Bool = true
    var needsNav: Bool = true

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }

    deinit {
        if webView != nil {
            webView.removeObserver(self, forKeyPath: "estimatedProgress")
        }
        progressView.removeFromSuperview()
    }

    override func loadView() {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = RequestManager.shared.processPool
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressBar()
        setupNavBar()
        setupToolbar()
        setupActionSheet()
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.allowsBackForwardNavigationGestures = true
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldLoad {
            loadURL(urlOpt: url)
        }
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    /// Try to load a URL into the webView if not nil
    ///
    /// - Parameter urlOpt: an optional URL
    func loadURL(urlOpt: URL?) {
        guard let url = urlOpt else {
            return
        }
        webView.load(URLRequest(url: url))
        shouldLoad = false
    }

    func setURL(url: URL?) {
        self.url = url
    }

    /// Download from URL and present DocumentInteractionController to act on downloaded file
    ///
    /// - Parameter url: the URL to download from
    func downloadAndPresentInteractionController(url: URL?) {
        guard let url = url else {
            return
        }
        interactionButton.isEnabled = false
        RequestManager.shared.downloadToDocuments(url: url) { [weak self] fileUrl in
            guard let fileUrl = fileUrl else {
                return
            }
            guard let button = self?.interactionButton else {
                return
            }
            self?.interactionController = UIDocumentInteractionController(url: fileUrl)
            DispatchQueue.main.async {
                self?.interactionController.presentOpenInMenu(from: button, animated: true)
                self?.interactionButton.isEnabled = true
            }
        }
    }
}

// MARK: View setup and controller configuration

fileprivate extension WebController {
    func setupNavBar() {
        if needsNav {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                                                    action: #selector(pop))
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self,
                                                                     action: #selector(loadWebview))
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.toolbar.tintColor = AppGlobals.sakaiRed
    }

    func setupProgressBar() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.tintColor = AppGlobals.sakaiRed
        navigationController?.navigationBar.addSubview(progressView)
        guard let navigationBarBounds = self.navigationController?.navigationBar.bounds else {
            return
        }
        progressView.frame = CGRect(x: 0, y: navigationBarBounds.size.height - 2,
                                    width: navigationBarBounds.size.width, height: 8)
    }

    func setupToolbar() {
        let backButtonImage = UIImage(named: "back_button")
        let forwardButtonImage = UIImage(named: "forward_button")
        flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(goBack))
        interactionButton = UIBarButtonItem(barButtonSystemItem: .action,target: self,
                                            action: #selector(presentDownloadOption))
        forwardButton = UIBarButtonItem(image: forwardButtonImage, style: .plain, target: self, action: #selector(goForward))
        let arr: [UIBarButtonItem] = [backButton, flexButton, interactionButton, flexButton, forwardButton]
        self.setToolbarItems(arr, animated: true)
    }

    /// Configure action sheet to present Download option for a file/URL
    func setupActionSheet() {
        let downloadAction = UIAlertAction(title: "Download", style: .default) { [weak self] (_) in
            self?.downloadAndPresentInteractionController(url: self?.url)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionController.addAction(downloadAction)
        actionController.addAction(cancelAction)
    }
}

// MARK: Selector actions

private extension WebController {
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

    @objc func presentDownloadOption() {
        self.present(actionController, animated: true, completion: nil)
    }

    @objc func canRotate() {}
}

// MARK: WKUIDelegate and WKNavigationDelegate impl.

extension WebController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.progressView.isHidden = true
        }
        // Remove distracting and unintuitive HTML elements from Sakai interface
        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';")
        webView.evaluateJavaScript("""
            $('.Mrphs-topHeader').remove();
            $('.Mrphs-siteHierarchy').remove();
            $('#toolMenuWrap').remove();
            $('#skipNav').remove();
            var selectedElement = document.querySelector('#content');
            document.body.innerHTML = selectedElement.innerHTML;
        """)
    }

    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
