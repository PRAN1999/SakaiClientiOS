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

    var bottomConstraint: NSLayoutConstraint!

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
        let margins = layoutMarginsGuide

        webView.constrainToEdges(of: self, onSides: [.top, .left, .right])
        webView.bottomAnchor.constraint(equalTo: messageBar.topAnchor).isActive = true

        messageBar.constrainToEdges(of: self, onSides: [.left, .right])
        messageBar.heightAnchor.constraint(greaterThanOrEqualTo: margins.heightAnchor,
                                           multiplier: 0.1)

        bottomConstraint = messageBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        addConstraint(bottomConstraint)
    }
}
