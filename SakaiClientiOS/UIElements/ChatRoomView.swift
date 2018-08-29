//
//  ChatRoomView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/27/18.
//

import UIKit
import WebKit

class ChatRoomView: UIView {
    
    var webView: WKWebView!
    var messageBar: MessageBar!
    
    var bottomConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = RequestManager.shared.processPool
        webView = WKWebView(frame: .zero, configuration: configuration)
        
        messageBar = MessageBar()
    }
    
    func addViews() {
        self.addSubview(webView)
        self.addSubview(messageBar)
    }
    
    func setConstraints() {
        let margins = self.layoutMarginsGuide
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        messageBar.translatesAutoresizingMaskIntoConstraints = false
        
        webView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: messageBar.topAnchor).isActive = true
        
        messageBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        messageBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        messageBar.heightAnchor.constraint(greaterThanOrEqualTo: margins.heightAnchor, multiplier: 0.1)
        
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
