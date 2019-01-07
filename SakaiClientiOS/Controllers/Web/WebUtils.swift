//
//  WebUtils.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/2/18.
//

import Foundation
import WebKit
import SafariServices

extension WKWebView {
    /// Returns a webview with Sakai authentication cookies inserted into
    /// configuration so Sakai links can be loaded.
    ///
    /// Due to a bug with WKWebsiteDataStore.shared where cookies from
    /// HTTPCookieStorage are not automatically inserted into the store
    /// and cookies set manually don't seem to to persist, a non-persistent
    /// data store must be created and configured for every WKWebView shown
    /// in the app
    ///
    /// - Parameters:
    ///   - webService: a service to provide a shared processPool
    ///   - completion: callback with configured WKWebView
    static func authorizedWebView(webService: WebService,
                                  completion: @escaping (WKWebView) -> Void) {
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

extension SFSafariViewController {
    static func defaultSafariController(url: URL) -> SFSafariViewController {
        let safariController = SFSafariViewController(url: url)
        safariController.preferredBarTintColor = Palette.main.primaryBackgroundColor
        safariController.preferredControlTintColor = Palette.main.primaryTextColor
        return safariController
    }
}
