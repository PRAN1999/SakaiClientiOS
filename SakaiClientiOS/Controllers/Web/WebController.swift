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

    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.tintColor = AppGlobals.sakaiRed
        return progressView
    }()

    // MARK: Navigation and toolbar items

    private let backButton: UIBarButtonItem = {
        let backButtonImage = UIImage(named: "back_button")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: nil, action: nil)
        return backButton
    }()

    private let forwardButton: UIBarButtonItem = {
        let forwardButtonImage = UIImage(named: "forward_button")
        let forwardButton = UIBarButtonItem(image: forwardButtonImage, style: .plain, target: nil, action: nil)
        return forwardButton
    }()

    private let interactionButton = UIBarButtonItem(barButtonSystemItem: .action,target: nil, action: nil)
    private let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

    // MARK: Custom view controllers

    private let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    private var interactionController: UIDocumentInteractionController?

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
        //hidesBottomBarWhenPushed = true
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
        WKWebView.authorizedWebView { [weak self] webView in
            webView.uiDelegate = self
            webView.navigationDelegate = self
            if let view = self?.view {
                UIView.constrainChildToEdges(child: webView, parent: view)
            }

            // Normal pop recognizer is buggy with WKWebView
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self?.pop))
            swipeRight.direction = .right
            webView.addGestureRecognizer(swipeRight)

            if let target = self {
                webView.addObserver(target, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            }

            webView.allowsBackForwardNavigationGestures = false

            self?.webView = webView
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
        if needsNav {
            navigationController?.setToolbarHidden(false, animated: true)
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Set orientation to portrait if in landscape
        if isMovingFromParentViewController {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
        navigationController?.setToolbarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        print("Trying to dismiss from WebController...")
        if (self.presentedViewController != nil) {
            super.dismiss(animated: flag, completion: completion)
        }
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
        navigationItem.leftBarButtonItem?.isEnabled = false
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
                self?.interactionController?.presentOpenInMenu(from: button, animated: true)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pop))
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadWebview))
        if !needsNav {
            navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.setToolbarHidden(true, animated: true)
        }
        navigationController?.toolbar.tintColor = AppGlobals.sakaiRed
    }

    /// Attach progress bar to navigation bar frame to track webView loads
    func setupProgressBar() {
        navigationController?.navigationBar.addSubview(progressView)
        guard let navigationBarBounds = navigationController?.navigationBar.bounds else {
            return
        }
        progressView.frame = CGRect(x: 0,
                                    y: navigationBarBounds.size.height - 2,
                                    width: navigationBarBounds.size.width,
                                    height: 8)
    }

    /// Configure navigation toolbar with webView action buttons
    func setupToolbar() {
        backButton.target = self; backButton.action = #selector(goBack)
        forwardButton.target = self; forwardButton.action = #selector(goForward)
        interactionButton.target = self; interactionButton.action = #selector(presentDownloadOption)

        let arr: [UIBarButtonItem] = [backButton, flexButton, interactionButton, flexButton, forwardButton]
        setToolbarItems(arr, animated: true)
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
        navigationController?.popViewController(animated: true)
    }

    @objc func presentDownloadOption() {
        present(actionController, animated: true, completion: nil)
    }

    /// Allows rotation of controller
    @objc func canRotate() {}
}
