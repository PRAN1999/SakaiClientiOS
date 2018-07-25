//
//  SitePageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/24/18.
//

import UIKit

protocol SitePageController: class {
    
    init()
    
    var siteId: String? { get set }
}