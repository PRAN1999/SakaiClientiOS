//
//  WebNavigationController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/11/18.
//

import UIKit

/// Used to contain webView when being presented from popup
class WebViewNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = Palette.main.toolBarColor
        navigationBar.barTintColor = Palette.main.navigationBackgroundColor
        navigationBar.barStyle = Palette.main.barStyle
        toolbar.tintColor = Palette.main.toolBarColor
        toolbar.barStyle = Palette.main.barStyle
        toolbar.barTintColor = Palette.main.tabBarBackgroundColor
    }
}
