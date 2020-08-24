//
//  ChatRoomViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/26/18.
//

import Foundation
import WebKit

/// Since API's are not easily available for Sakai's chat room interface,
/// the ChatRoomViewController manages a webView and a message bar to simulate
/// a real chat application. By executing JavaScript to modify the webview,
/// this screen allows users to see and post messages to the Sakai chat
/// with a mobile interface
class ChatRoomViewController: UIViewController {

    private var chatRoomView: ChatRoomView!
    private var edgeInteractionController: LeftEdgeInteractionController!
    
    private lazy var indicator = LoadingIndicator(view: view)
    private var webView: WKWebView {
        return chatRoomView.webView
    }

    private var chatChannelId: String?
    private var csrftoken: String?

    private let siteId: String
    private let siteUrl: String

    private let networkService: NetworkService
    private let webService: WebService
    private let chatService: ChatService

    required convenience init(siteId: String, siteUrl: String) {
        let networkService = RequestManager.shared
        let webService = RequestManager.shared
        self.init(siteId: siteId, siteUrl: siteUrl, networkService: networkService, webService: webService)
    }

    init(siteId: String, siteUrl: String, networkService: NetworkService, webService: WebService) {
        self.siteId = siteId
        self.siteUrl = siteUrl
        self.networkService = networkService
        self.webService = webService
        self.chatService = ChatService(networkService: networkService)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Palette.main.primaryBackgroundColor
        title = "Chat Room"

        indicator = LoadingIndicator(view: view)
        indicator.startAnimating()

        WKWebView.authorizedWebView(webService: webService) { [weak self] webView in
            webView.isHidden = true
            self?.chatRoomView = ChatRoomView(webView: webView)
            self?.setup()
        }
    }

    private func setup() {
        chatRoomView.backgroundColor = Palette.main.primaryBackgroundColor
        webView.backgroundColor = Palette.main.primaryBackgroundColor

        view.addSubview(chatRoomView)
        view.bringSubviewToFront(indicator)
        chatRoomView.constrainToEdges(of: view)

        chatRoomView.messageBar.sendButton.addTarget(
            self,
            action: #selector(handleSubmit),
            for: .touchUpInside
        )
        setInput(enabled: false)
        chatRoomView.addKeyboardObservers()

        edgeInteractionController = LeftEdgeInteractionController(view: chatRoomView, in: self)

        // Force the webView to be static and unable to be zoomed so that
        // it behaves more like a native UI element
        webView.contentMode = .scaleToFill
        webView.isMultipleTouchEnabled = false
        webView.scrollView.delegate = NativeWebViewScrollViewDelegate.shared
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.uiDelegate = self
        webView.navigationDelegate = self
        guard let url = URL(string: siteUrl) else {
            return
        }
        webView.load(URLRequest(url: url))
    }

    private func setInput(enabled: Bool) {
        chatRoomView.messageBar.inputField.isEditable = enabled
        chatRoomView.messageBar.sendButton.isEnabled = enabled
    }

    @objc private func handleSubmit() {
        guard let text = chatRoomView.messageBar.inputField.text else {
            return
        }
        guard text != "" else {
            return
        }
        chatService.submitMessage(text: text, channelId: chatChannelId, csrf: csrftoken) { [weak self] in
            self?.updateMonitor()
        }
        chatRoomView.messageBar.inputField.text = ""
    }

    private func updateMonitor() {
        webView.evaluateJavaScript("updateNow();") { [weak self] (_, _) in
            self?.webView.scrollToBottom()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // For some reason, when using the custom swip to go back, the
        // message bar disappears if the transition is started and cancelled
        // It may have something to do with the tabbar but forcing the view
        // to layout lets the message bar reappear after a cancelled transition
        view.setNeedsLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent && UIDevice.current.userInterfaceIdiom == .phone {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        view.setNeedsLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        webView.scrollToBottom()
    }
}

// MARK: WKUIDelegate && WKNavigationDelegate Extension

extension ChatRoomViewController: WKUIDelegate, WKNavigationDelegate {

    /// Remove all elements from the HTML except for the chat room and
    /// retrieve chat room information from JavaScript local variables
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        let group = DispatchGroup()

        group.enter()
        webView.evaluateJavaScript("currentChatChannelId") { [weak self] (data, _) in
            guard let id = data as? String else {
                self?.presentErrorAlert(string: "Unable to load chat")
                group.leave()
                return
            }
            self?.chatChannelId = id
            group.leave()
        }

        group.enter()
        let css = """
        { list-style: none; border: 1px grey solid; padding: 6px; margin: 8px 12px; border-radius: 6px; \
        box-shadow:-3px 3px 3px lightgrey; }
        """
        webView.evaluateJavaScript("""
            var csrftoken = document.getElementById('topForm:csrftoken').value;
            var monitor = document.querySelector('#Monitor');
            document.body.innerHTML = monitor.innerHTML;

            $('body').css({'background': 'white'});
            $('.chatList').css({'padding': '0em'});
            $("<style type='text/css'> li \(css) </style>").appendTo("head");

            // Returns the csrf token
            csrftoken;
            """, completionHandler: { [weak self] (data, _) in
                guard let token = data as? String else {
                    self?.presentErrorAlert(string: "Unable to load chat")
                    group.leave()
                    return
                }
                self?.csrftoken = token
                group.leave()
            }
        )

        group.notify(queue: .main, work: DispatchWorkItem(block: { [weak self] in
            self?.setInput(enabled: true)
            self?.indicator.stopAnimating()
            self?.webView.scrollToBottom()
            webView.isHidden = false
        }))
    }
}

extension ChatRoomViewController: NavigationAnimatable {
    func animationControllerForPop(to controller: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if edgeInteractionController.edge?.state == .began {
            return SystemPopAnimator(duration: 0.5, interactionController: edgeInteractionController)
        }
        return nil
    }

    func animationControllerForPush(to controller: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

extension ChatRoomViewController: Rotatable {}
