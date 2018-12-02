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

    var webView: WKWebView!
    var messageBar: MessageBar!
    var bottomConstraint: NSLayoutConstraint!

    var shouldSetConstraints = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        if shouldSetConstraints {
            setConstraints()
            shouldSetConstraints = false
        }
        super.updateConstraints()
    }

    func setup() {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = RequestManager.shared.processPool
        webView = WKWebView(frame: .zero, configuration: configuration)
        messageBar = MessageBar()

        webView.translatesAutoresizingMaskIntoConstraints = false
        messageBar.translatesAutoresizingMaskIntoConstraints = false
        setNeedsUpdateConstraints()
    }

    func addViews() {
        self.addSubview(webView)
        self.addSubview(messageBar)
    }

    func setConstraints() {
        let margins = self.layoutMarginsGuide

        webView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: messageBar.topAnchor).isActive = true

        messageBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        messageBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        messageBar.heightAnchor.constraint(greaterThanOrEqualTo: margins.heightAnchor,
                                           multiplier: 0.1)

        bottomConstraint = NSLayoutConstraint(item: self.messageBar,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: 0)
        self.addConstraint(bottomConstraint)
    }
}
