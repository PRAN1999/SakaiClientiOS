//
//  DefaultController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/13/18.
//

import UIKit

class DefaultController: WebController, SitePageController {
    
    var siteId: String?
    var siteUrl: String?
    
    required override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        guard let siteUrl = siteUrl else {
            return
        }
        guard let url = URL(string: siteUrl) else {
            return
        }
        setURL(url: url)
        super.viewDidLoad()
    }

}
