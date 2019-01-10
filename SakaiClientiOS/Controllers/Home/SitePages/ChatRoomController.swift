//
//  ChatRoomController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/26/18.
//

import Foundation
import WebKit

/// Since API's are not easily available for Sakai's chat room interface,
/// the ChatRoomController manages a webView and a message bar to simulate
/// a real chat application. By executing JavaScript to modify the webview,
/// this screen allows users to see and post messages to the Sakai chat
/// with a mobile interface
class ChatRoomController: UIViewController, SitePageController {

    private var chatRoomView: ChatRoomView!
    private var indicator: LoadingIndicator!
    private var webView: WKWebView {
        return chatRoomView.webView
    }

    private var chatChannelId: String?
    private var csrftoken: String?

    private let siteId: String
    private let siteUrl: String

    private let networkService: NetworkService
    private let webService: WebService

    required convenience init(siteId: String,
                              siteUrl: String,
                              pageTitle: String) {
        let networkService = RequestManager.shared
        let webService = RequestManager.shared
        self.init(siteId: siteId,
                  siteUrl: siteUrl,
                  networkService: networkService,
                  webService: webService)
    }

    init(siteId: String,
         siteUrl: String,
         networkService: NetworkService,
         webService: WebService) {
        self.siteId = siteId
        self.siteUrl = siteUrl
        self.networkService = networkService
        self.webService = webService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.main.primaryBackgroundColor
        title = "Chat Room"

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardNotification(notification:)),
            name: .UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardNotification(notification:)),
            name: .UIKeyboardWillHide,
            object: nil
        )

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
        view.bringSubview(toFront: indicator)
        chatRoomView.constrainToEdges(of: view)
        chatRoomView.messageBar.inputField.chatDelegate.delegate(to: self) { (self) in
            self.handleSubmit()
        }
        chatRoomView.messageBar.sendButton.addTarget(
            self,
            action: #selector(handleSubmit),
            for: .touchUpInside
        )
        guard let url = URL(string: siteUrl) else {
            return
        }
        setInput(enabled: false)

        // Force the webView to be static and unable to be zoomed so that
        // it behaves more like a native UI element
        webView.contentMode = .scaleToFill
        webView.isMultipleTouchEnabled = false
        webView.scrollView.delegate = NativeWebViewScrollViewDelegate.shared
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
    }
    
    @objc private func handleKeyboardNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        
        // If the keyboard is showing, the messagebar needs to travel up
        // with it and if it is hidden, the messagebar should slide back
        // down. Additionally, if the keyboard is going to show, the chat
        // needs to scroll down to the latest messages.
        let cgRect = keyboardFrame.cgRectValue
        let isKeyboardShowing = notification.name == .UIKeyboardWillShow
        chatRoomView.bottomConstraint
            .constant = isKeyboardShowing ? -cgRect.height : 0

        UIView.animate(withDuration: 0,
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)

        if isKeyboardShowing {
            updateChatOnKeyboardNotification()
        }
    }
    
    @objc private func scrollToBottom() {
        webView.evaluateJavaScript(
            "$('html, body').animate({scrollTop:document.body.offsetHeight}, 400);",
            completionHandler: nil)
    }
    
    private func updateChatOnKeyboardNotification() {
        webView.evaluateJavaScript(
        "document.body.scrollTop == document.body.offsetHeight") {
            [weak self] (data, err) in
            guard let isAtBottom = data as? Bool else {
                return
            }
            if !isAtBottom {
                self?.scrollToBottom()
            }
        }
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
        submitMessage(text)
        chatRoomView.messageBar.inputField.text = nil
    }
    
    private func submitMessage(_ text: String) {
        guard
            let csrftoken = csrftoken,
            let chatChannelId = chatChannelId
            else {
                return
        }
        let parameters = [
            "body": text,
            "chatChannelId": chatChannelId,
            "csrftoken": csrftoken
        ]
        // The Response to the POST request is not something that can be
        // decoded, so an UndefinedResponse struct is used
        let request = SakaiRequest<UndefinedResponse>(endpoint: .newChat,
                                                      method: .post,
                                                      parameters: parameters)
        networkService.makeEndpointRequest(request: request) {
            [weak self] res, err in
            self?.updateMonitor()
        }
    }
    
    private func updateMonitor() {
        webView.evaluateJavaScript("updateNow();") {
            [weak self] (data, err) in
            self?.scrollToBottom()
        }
    }
}

// MARK: WKUIDelegate && WKNavigationDelegate Extension

extension ChatRoomController: WKUIDelegate, WKNavigationDelegate {

    /// Remove all elements from the HTML except for the chat room and
    /// retrieve chat room information from JavaScript local variables
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        let group = DispatchGroup()

        group.enter()
        webView.evaluateJavaScript("currentChatChannelId") {
            [weak self] (data, err) in
            guard let id = data as? String else {
                return
            }
            self?.chatChannelId = id
            group.leave()
        }

        group.enter()
        webView.evaluateJavaScript("""
            var csrftoken = document.getElementById('topForm:csrftoken').value;
            var monitor = document.querySelector('#Monitor');
            document.body.innerHTML = monitor.innerHTML;

            $('body').css({'background': 'white'});
            $('.chatList').css({'padding': '0em'});
            $("<style type='text/css'> li { list-style: none; border: 1px grey solid; padding: 6px; margin: 8px 12px; border-radius: 6px; box-shadow:-3px 3px 3px lightgrey; }</style>").appendTo("head");

            // Returns the csrf token
            csrftoken;
            """, completionHandler: { [weak self] (data, err) in
                guard let token = data as? String else {
                    return
                }
                self?.csrftoken = token
                self?.scrollToBottom()
                group.leave()
            }
        )

        group.notify(queue: .main, work: DispatchWorkItem(block: { [weak self] in
            self?.setInput(enabled: true)
            self?.indicator.stopAnimating()
            webView.isHidden = false
        }))
    }
}
