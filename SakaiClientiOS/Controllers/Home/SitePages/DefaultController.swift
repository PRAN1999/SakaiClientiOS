//
//  DefaultController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/13/18.
//

import UIKit

class DefaultController: WebController, SitePageController {
    
    var siteId: String?
    
    required override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
