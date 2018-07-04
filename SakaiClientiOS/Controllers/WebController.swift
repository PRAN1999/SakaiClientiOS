//
//  WebController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit
import WebKit

class WebController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    var url:URL?
    
    /**
     
     Sets the webview delegates for navigation and UI to the view controller itself,
     allowing the view controller to directly control the webview appearance and requests
     
     */
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = RequestManager.shared.processPool
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self;
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pop))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        loadURL(urlOpt: self.url)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        if (self.isMovingFromParentViewController) {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
//        if toInterfaceOrientation == .landscapeLeft || toInterfaceOrientation == .landscapeRight {
//            self.tabBarController?.tabBar.isHidden = true
//        } else {
//            self.tabBarController?.tabBar.isHidden = false
//        }
//    }
    
    func loadURL(urlOpt:URL?) {
        guard let url = urlOpt else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    func setURL(url:URL) {
        self.url = url
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func canRotate() -> Void {
        
    }
}

extension UIViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let webController = WebController()
        webController.setURL(url: URL)
        
        self.navigationController?.pushViewController(webController, animated: true)
        
        return false
    }
}
