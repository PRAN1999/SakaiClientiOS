//
//  WebViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit
import WebKit
import SafariServices

/// A WKWebView controller to display and navigate custom Sakai webpages
/// and data.
///
/// Should be used across app to display any web page or content needing
/// Sakai authentication cookies to access URL. Any insecure HTTP URL will
/// be opened in SFSafariViewController instead
class WebViewController: UIViewController {

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.tintColor = Palette.main.highlightColor

        navigationController?.navigationBar.addSubview(progressView)
        guard let navigationBarBounds = navigationController?.navigationBar.bounds else {
            return progressView
        }
        let height = navigationBarBounds.size.height
        let width = navigationBarBounds.size.width
        progressView.frame = CGRect(x: 0, y: height - 2, width: width, height: 15)
        return progressView
    }()

    private lazy var toolBarArray: [UIBarButtonItem] = {
        let backImage = UIImage(named: "back_button")
        let back = UIBarButtonItem(image: backImage, style: .plain, target: webView, action: #selector(webView?.goBack))

        let forwardImage = UIImage(named: "forward_button")
        let forward = UIBarButtonItem(image: forwardImage, style: .plain, target: webView, action: #selector(webView?.goForward))

        let action = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(presentActions))
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        var arr = [back, flex, forward, flex, flex, flex]
        if allowsOptions {
            arr.append(action)
        }
        return arr
    }()

    private lazy var actionController: UIAlertController = {
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let downloadAction = UIAlertAction(title: "Download", style: .default) { [weak self] (_) in
            self?.downloadAndPresentInteractionController(url: self?.url)
        }
        let safariAction = UIAlertAction(title: "Open in Safari", style: .default) { [weak self] (_) in
            self?.openInSafari?(self?.url)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionController.addAction(downloadAction)
        actionController.addAction(safariAction)
        actionController.addAction(cancelAction)
        return actionController
    }()

    /// Manage SFSafariViewController presentation for non-Sakai URL
    lazy var openInSafari: ((URL?) -> Void)? = { [weak self] url in
        guard let url = url, url.absoluteString.contains("http") else {
            return
        }
        let safariController = SFSafariViewController.defaultSafariController(url: url)
        self?.shouldLoad = false
        self?.tabBarController?.present(safariController, animated: true, completion: nil)
    }

    /// Manage dismissing action for webView
    lazy var dismissAction: (() -> Void)? = { [weak self] in
        self?.navigationController?.popViewController(animated: true)
    }

    private var webView: WKWebView?
    private var edgeInteractionController: LeftEdgeInteractionController?
    private var interactionController: UIDocumentInteractionController?

    private var oldNavigationTintColor = Palette.main.navigationTintColor
    private var didInitialize = false
    private var shouldLoad = true
    
    private var url: URL?

    private let downloadService: DownloadService
    private let webService: WebService
    private let allowsOptions: Bool

    init(downloadService: DownloadService, webService: WebService, allowsOptions: Bool = true) {
        self.allowsOptions = allowsOptions
        self.downloadService = downloadService
        self.webService = webService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(:coder) is not supported")
    }

    convenience init(allowsOptions: Bool = true) {
        self.init(downloadService: RequestManager.shared,
                  webService: RequestManager.shared,
                  allowsOptions: allowsOptions)
    }

    deinit {
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.removeFromSuperview()
    }

    override func viewDidLoad() {
        WKWebView.authorizedWebView(webService: webService) { [weak self] webView in
            webView.uiDelegate = self
            webView.navigationDelegate = self
            if let view = self?.view {
                view.addSubview(webView)
                webView.constrainToEdges(of: view)
            }

            if let target = self {
                let keypath = #keyPath(WKWebView.estimatedProgress)
                webView.addObserver(target, forKeyPath: keypath, options: .new, context: nil)
                target.edgeInteractionController = LeftEdgeInteractionController(view: webView, in: target)
            }

            webView.allowsBackForwardNavigationGestures = false
            self?.webView = webView
            self?.loadURL(urlOpt: self?.url)
            self?.didInitialize = true

        }

        super.viewDidLoad()

        setToolbarItems(toolBarArray, animated: true)

        navigationItem.rightBarButtonItem
            = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadWebview))
        navigationItem.leftBarButtonItem
            = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissController))
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress", let progress = webView?.estimatedProgress {
            progressView.progress = Float(progress)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldLoad && didInitialize {
            loadURL(urlOpt: url)
        }
        if let color = navigationController?.navigationBar.tintColor {
            oldNavigationTintColor = color
        }
        navigationController?.navigationBar.tintColor = Palette.main.toolBarColor
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParentViewController && UIDevice.current.userInterfaceIdiom == .phone {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
        navigationController?.navigationBar.tintColor = oldNavigationTintColor
        navigationController?.setToolbarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    func loadURL(urlOpt: URL?) {
        guard let url = urlOpt, shouldLoad else {
            return
        }
        webView?.load(URLRequest(url: url))
        shouldLoad = false
    }

    func setNeedsLoad(to flag: Bool) {
        self.shouldLoad = flag
    }

    func setURL(url: URL?) {
        self.url = url
    }
}

extension WebViewController {
    /// Download from URL and present DocumentInteractionController to act
    /// on downloaded file. While file is being downloaded, lock the UI
    /// to prevent leaving the screen until the callback has returned.
    ///
    /// Prevents leaving ViewController until Download has called back -
    /// for success or failure
    /// - Parameter url: the URL to download from
    private func downloadAndPresentInteractionController(url: URL?) {
        guard let url = url else {
            return
        }

        let interactionButton = toolBarArray.last
        interactionButton?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        webView?.isHidden = true

        let indicator = LoadingIndicator(view: self.view)
        indicator.startAnimating()

        let didComplete = { [weak self] in
            self?.webView?.isHidden = false
            self?.navigationItem.leftBarButtonItem?.isEnabled = true
            interactionButton?.isEnabled = true
        }

        downloadService.downloadToDocuments(url: url) { [weak self] fileUrl in
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            guard let fileUrl = fileUrl else {
                didComplete()
                return
            }
            guard let button = interactionButton else {
                didComplete()
                return
            }
            self?.interactionController = UIDocumentInteractionController(url: fileUrl)
            DispatchQueue.main.async {
                self?.interactionController?.presentOpenInMenu(from: button, animated: true)
                didComplete()
            }
        }
    }
}

// MARK: WKUIDelegate and WKNavigationDelegate

extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        if !url.absoluteString.contains("https") {
            decisionHandler(.cancel)
            openInSafari?(url)
            return
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.progressView.isHidden = true
        }

        // Remove distracting and unintuitive HTML elements from Sakai
        // interface. This includes scrolling navigation bar and other
        // cluttering elements
        webView.evaluateJavaScript("""
            $('.Mrphs-topHeader').remove();
            $('.Mrphs-siteHierarchy').remove();
            $('#toolMenuWrap').remove();
            $('#skipNav').remove();
        """)
    }

    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {

        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

// MARK: Selector actions

extension WebViewController {

    @objc private func dismissController() {
        dismissAction?()
    }

    @objc private func presentActions() {
        guard let actionButton = toolBarArray.last else {
            return
        }
        actionController.popoverPresentationController?.barButtonItem = actionButton
        actionController.popoverPresentationController?.sourceView = view
        present(actionController, animated: true, completion: nil)
    }

    @objc func loadWebview() {
        shouldLoad = true
        loadURL(urlOpt: url)
    }
}

extension WebViewController: Rotatable {}

extension WebViewController: NavigationAnimatable {
    func animationControllerForPop(to controller: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let edgeController = edgeInteractionController, edgeController.edge?.state == .began {
            return SystemPopAnimator(duration: 0.5, interactionController: edgeController)
        }
        return nil
    }

    func animationControllerForPush(to controller: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

extension WebViewController: RichTextEditorViewControllerDelegate {}
