//
//  WebController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit
import WebKit

protocol WebviewLoaderDelegate {
    func openWebview(url:URL)
}

class WebController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    var url:URL?
    
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = AppGlobals.PROCESS_POOL
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self;
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadURL(urlOpt: self.url)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pop))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadURL(urlOpt:URL?) {
        guard let url = urlOpt else {
            return
        }
        //let temp = URL(string: "https://sakai.rutgers.edu/portal")
        webView.load(URLRequest(url: url))
    }
    
    func setURL(url:URL) {
        self.url = url
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }

}
