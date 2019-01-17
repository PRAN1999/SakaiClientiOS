//
//  ChatRoomView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/27/18.
//

import UIKit
import WebKit

/// The view to represent an custom chat interface where the webview displays the chat
class ChatRoomView: UIView {

    let webView: WKWebView

    let messageBar: MessageBar = UIView.defaultAutoLayoutView()

    lazy var bottomConstraint: NSLayoutConstraint = {
        let margins = layoutMarginsGuide
        return messageBar.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
    }()

    init(webView: WKWebView) {
        self.webView = webView
        super.init(frame: .zero)
        setupView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        webView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(webView)
        addSubview(messageBar)
    }

    private func setConstraints() {
        webView.constrainToEdges(of: self, onSides: [.top, .left, .right])
        webView.bottomAnchor.constraint(equalTo: messageBar.topAnchor).isActive = true

        messageBar.constrainToEdges(of: self, onSides: [.left, .right])
        messageBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

        bottomConstraint.isActive = true
    }
}

extension ChatRoomView: KeyboardUpdatable {
    func handleKeyboardNotification(notification: Notification) {
        self._handleKeyboardNotification(notification: notification)
        let isKeyboardShowing = notification.name == .UIKeyboardWillShow
        if isKeyboardShowing {
            webView.scrollToBottom()
        }
    }
}
