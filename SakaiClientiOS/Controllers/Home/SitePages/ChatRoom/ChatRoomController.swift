//
//  ChatRoomController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/26/18.
//

import Foundation
import WebKit

class ChatRoomController: UIViewController, SitePageController {
    
    var siteId: String?
    var siteUrl: String?
    var pageTitle: String?
    var chatChannelId: String?
    var csrftoken: String?
    
    var chatRoomView: ChatRoomView!
    var indicator: LoadingIndicator!
    
    var webView: WKWebView {
        return chatRoomView.webView
    }
    
    override func loadView() {
        chatRoomView = ChatRoomView(frame: UIScreen.main.bounds)
        self.view = chatRoomView
    }
    
    required init() {
        // Placeholder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.title = "Chat Room"

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: .UIKeyboardWillHide, object: nil)

        chatRoomView.messageBar.inputField.chatDelegate.delegate(to: self) { (self) in
            self.handleSubmit()
        }
        chatRoomView.messageBar.sendButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        guard let urlString = siteUrl else {
            return
        }
        guard let url = URL(string: urlString) else {
            return
        }
        
        indicator = LoadingIndicator(view: self.view)
        indicator.startAnimating()
        
        setInput(enabled: false)
        
        webView.contentMode = .scaleToFill
        webView.isMultipleTouchEnabled = false
        webView.scrollView.delegate = NativeWebViewScrollViewDelegate.shared
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
    }
    
    @objc func handleKeyboardNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let cgRect = keyboardFrame.cgRectValue
        let isKeyboardShowing = notification.name == .UIKeyboardWillShow
        chatRoomView.bottomConstraint.constant = isKeyboardShowing ? -cgRect.height : 0
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
        if isKeyboardShowing {
            self.updateChatOnKeyboardNotification()
        }
    }
    
    @objc func scrollToBottom() {
        webView.evaluateJavaScript("$('html, body').animate({scrollTop:document.body.offsetHeight}, 400);", completionHandler: nil)
    }
    
    func updateChatOnKeyboardNotification() {
        webView.evaluateJavaScript("document.body.scrollTop == document.body.offsetHeight") { [weak self] (data, err) in
            guard let isAtBottom = data as? Bool else {
                return
            }
            if !isAtBottom {
                self?.scrollToBottom()
            }
        }
    }
    
    func setInput(enabled: Bool) {
        chatRoomView.messageBar.inputField.isEditable = enabled
        chatRoomView.messageBar.sendButton.isEnabled = enabled
    }
    
    @objc func handleSubmit() {
        guard let text = chatRoomView.messageBar.inputField.text else {
            return
        }
        guard text != "" else {
            return
        }
        submitMessage(text)
        chatRoomView.messageBar.inputField.text = nil
    }
    
    func submitMessage(_ text: String) {
        guard let csrftoken = csrftoken, let chatChannelId = chatChannelId else {
            return
        }
        SakaiService.shared.submitMessage(text: text, csrftoken: csrftoken, chatChannelId: chatChannelId) { [weak self] err in
            self?.updateMonitor()
        }
    }
    
    func updateMonitor() {
        webView.evaluateJavaScript("updateNow();") { [weak self] (data, err) in
            self?.scrollToBottom()
        }
    }
}

extension ChatRoomController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("currentChatChannelId") { [weak self] (data, err) in
            guard err == nil else {
                self?.navigationController?.popViewController(animated: true)
                return
            }
            guard let id = data as? String else {
                return
            }
            self?.chatChannelId = id
            if self?.csrftoken != nil {
                self?.setInput(enabled: true)
            }
        }
        
        webView.evaluateJavaScript("""
            var csrftoken = document.getElementById('topForm:csrftoken').value;
            var selectedElement = document.querySelector('#Monitor');
            document.body.innerHTML = selectedElement.innerHTML;
            csrftoken;
            """, completionHandler: { [weak self] (data, err) in
            guard err == nil else {
                self?.navigationController?.popViewController(animated: true)
                return
            }
            guard let token = data as? String else {
                return
            }
            self?.csrftoken = token
            self?.scrollToBottom()
            
            if self?.chatChannelId != nil {
                self?.setInput(enabled: true)
            }
            self?.indicator.stopAnimating()
        })
    }
}
