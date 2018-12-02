//
//  SitePageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/24/18.
//

import UIKit

protocol SitePageController: class {

    var siteId: String { get set }
    var siteUrl: String { get set }
    var pageTitle: String { get set }

    init(siteId: String, siteUrl: String, pageTitle: String)
}
