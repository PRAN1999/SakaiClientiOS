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

        webView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: messageBar.topAnchor).isActive = true

        messageBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        messageBar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        messageBar.heightAnchor.constraint(greaterThanOrEqualTo: margins.heightAnchor,
                                           multiplier: 0.1)

        bottomConstraint = NSLayoutConstraint(item: messageBar,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: 0)
        addConstraint(bottomConstraint)
    }
}
