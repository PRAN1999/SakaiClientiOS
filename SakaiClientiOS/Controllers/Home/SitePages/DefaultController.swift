//
//  DefaultController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/13/18.
//

import UIKit

class DefaultController: WebController, SitePageController {
    
    private let siteId: String
    private let siteUrl: String
    private let pageTitle: String
    
    required init(siteId: String, siteUrl: String, pageTitle: String) {
        self.siteId = siteId
        self.siteUrl = siteUrl
        self.pageTitle = pageTitle
        super.init()
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
