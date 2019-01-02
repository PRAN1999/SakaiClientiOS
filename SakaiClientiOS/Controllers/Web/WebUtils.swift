//
//  WebUtils.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/2/18.
//

import Foundation
import WebKit

extension WKWebView {

    static func authorizedWebView(webService: WebService, completion: @escaping (WKWebView) -> Void) {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = webService.processPool
        let dataStore = WKWebsiteDataStore.nonPersistent()
        let dispatchGroup = DispatchGroup()
        let cookies = webService.cookies ?? []
        for cookie in cookies {
            dispatchGroup.enter()
            dataStore.httpCookieStore.setCookie(cookie) {
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            configuration.websiteDataStore = dataStore
            let webView = WKWebView(frame: .zero, configuration: configuration)
            completion(webView)
        }
    }
}
