//
//  WebController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit
import WebKit
import SafariServices

/// A WKWebView controller to display and navigate custom Sakai webpages and data.
///
/// Should be used across app to display any web page or content needing Sakai
/// authentication cookies to access URL. Any insecure HTTP URL will be opened
/// in SFSafariViewController instead
class WebController: UIViewController {

    // MARK: Views

    var webView: WKWebView!
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

    private var didInitialize = false
    var shouldLoad: Bool = true
    var needsNav: Bool = true

    /// Manage SFSafariViewController presentation for insecure or non-sakai URL
    var openInSafari: ((URL?) -> Void)?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(:coder) is not supported")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
        // default SFSafariViewController presentation method
        openInSafari = { [weak self] url in
            guard let url = url, url.absoluteString.contains("http") else {
                return
            }
            let safariController = SFSafariViewController(url: url)
            self?.tabBarController?.present(safariController, animated: true, completion: nil)
        }
    }

    deinit {
        if webView != nil {
            webView.removeObserver(self, forKeyPath: "estimatedProgress")
            progressView.removeFromSuperview()
        }
    }

    override func viewDidLoad() {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = RequestManager.shared.processPool
        let dataStore = WKWebsiteDataStore.nonPersistent()
        let dispatchGroup = DispatchGroup()
        let cookies = RequestManager.shared.getCookies() ?? []
        for cookie in cookies {
            dispatchGroup.enter()
            dataStore.httpCookieStore.setCookie(cookie) {
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            configuration.websiteDataStore = dataStore
            self?.webView = WKWebView(frame: .zero, configuration: configuration)
            self?.webView.uiDelegate = self
            self?.webView.navigationDelegate = self
            if let wk = self?.webView, let view = self?.view {
                UIView.constrainChildToEdges(child: wk, parent: view)
            }

            // Normal pop recognizer is buggy with WKWebView
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self?.pop))
            swipeRight.direction = .right
            self?.webView.addGestureRecognizer(swipeRight)

            if let target = self {
                self?.webView.addObserver(target, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            }

            self?.webView.allowsBackForwardNavigationGestures = false
            self?.loadURL(urlOpt: self?.url)
            self?.didInitialize = true
        }

        super.viewDidLoad()
        setupProgressBar()
        setupNavBar()
        setupToolbar()
        setupActionSheet()
    }

    /// Update progressView with respect to webview load
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
        if shouldLoad && didInitialize {
            loadURL(urlOpt: url)
        }
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Set orientation to portrait if in landscape
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
        if !shouldLoad {
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
    /// Prevents leaving ViewController until Download has called back - for success or failure
    /// - Parameter url: the URL to download from
    func downloadAndPresentInteractionController(url: URL?) {
        guard let url = url else {
            return
        }
        interactionButton.isEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        let indicator = LoadingIndicator(view: self.view)
        indicator.startAnimating()
        RequestManager.shared.downloadToDocuments(url: url) { [weak self] fileUrl in
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            self?.navigationItem.leftBarButtonItem?.isEnabled = true
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

// MARK: WKUIDelegate and WKNavigationDelegate

extension WebController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        if !url.absoluteString.contains("https") {
            decisionHandler(.cancel)
            print(url)
            openInSafari?(url)
            return
        }
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
        // Prevent 3D-touch peek and show due to WebKit bug where view controller is dismissed twice
        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';")

        // Remove distracting and unintuitive HTML elements from Sakai interface
        // This includes scrolling navigation bar and other cluttering elements
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

// MARK: View setup and controller configuration

fileprivate extension WebController {
    func setupNavBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pop))
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadWebview))
        if !needsNav {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.toolbar.tintColor = AppGlobals.sakaiRed
    }

    /// Attach progress bar to navigation bar frame to track webView loads
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

    /// Configure navigation toolbar with webView action buttons
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

    /// Configure action sheet to present Download and Open in Safari option for a file/URL
    func setupActionSheet() {
        let downloadAction = UIAlertAction(title: "Download", style: .default) { [weak self] (_) in
            self?.downloadAndPresentInteractionController(url: self?.url)
        }
        let safariAction = UIAlertAction(title: "Open in Safari", style: .default, handler: { [weak self] (_) in
            self?.openInSafari?(self?.url)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionController.addAction(downloadAction)
        actionController.addAction(safariAction)
        actionController.addAction(cancelAction)
    }
}

// MARK: Selector actions

extension WebController {
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

    /// Allows rotation of controller
    @objc func canRotate() {}
}
