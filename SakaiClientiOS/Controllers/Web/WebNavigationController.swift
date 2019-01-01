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
        self.navigationBar.tintColor = AppGlobals.sakaiRed
        self.navigationBar.barStyle = .black
        self.toolbar.tintColor = AppGlobals.sakaiRed
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        print("Trying to dismiss...")
        if (self.presentedViewController != nil) {
            super.dismiss(animated: flag, completion: completion)
        }
    }
}
