//
//  WebUtils.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/2/18.
//

import Foundation
import WebKit

extension WKWebView {
    static func authorizedWebView(completion: @escaping (WKWebView) -> Void) {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = RequestManager.shared.processPool
        let dataStore = WKWebsiteDataStore.nonPersistent()
        let dispatchGroup = DispatchGroup()
        let cookies = RequestManager.shared.getCookies() ?? []
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
