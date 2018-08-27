//
//  ChatRoomController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/26/18.
//

import Foundation
import WebKit

class ChatRoomController: WebController, SitePageController {
    
    var siteId: String?
    
    override required init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.contentMode = .scaleToFill
        webView.scrollView.delegate = NativeWebViewScrollViewDelegate.shared
        webView.isMultipleTouchEnabled = false
    }
    
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        super.webView(webView, didFinish: navigation)
        let script = "var selectedElement = document.querySelector('#Monitor');document.body.innerHTML = selectedElement.innerHTML;"
        webView.evaluateJavaScript(script, completionHandler: nil)
        //webView.evaluateJavaScript(chatRoom, completionHandler: nil)
    }
}

class NativeWebViewScrollViewDelegate: NSObject, UIScrollViewDelegate {
    // MARK: - Shared delegate
    static var shared = NativeWebViewScrollViewDelegate()
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
