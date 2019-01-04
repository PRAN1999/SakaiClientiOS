//
//  WebNavigationController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/11/18.
//

import UIKit

/// A container navigation controller for a WebController
///
/// Used to circumvent the WebKit error where attempting to select a file
/// for input results in the dismiss method being called twice
class WebViewNavigationController: UINavigationController {

    private weak var documentPicker: UIDocumentPickerViewController?

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
