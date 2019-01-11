//
//  DefaultController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/13/18.
//

import UIKit

/// Open non-native SitePages in a WebView
class DefaultController: WebController {

    private let siteUrl: String
    private let pageTitle: String
    
    required convenience init(siteUrl: String, pageTitle: String) {
        self.init(siteUrl: siteUrl,
                  pageTitle: pageTitle,
                  downloadService: RequestManager.shared,
                  webService: RequestManager.shared)
    }

    init(siteUrl: String,
         pageTitle: String,
         downloadService: DownloadService,
         webService: WebService) {
        self.siteUrl = siteUrl
        self.pageTitle = pageTitle
        super.init(downloadService: downloadService, webService: webService)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        guard let url = URL(string: siteUrl) else {
            return
        }
        setURL(url: url)
        super.viewDidLoad()
        title = pageTitle
    }
}
