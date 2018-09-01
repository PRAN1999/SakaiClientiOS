//
//  WebNavigationController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/11/18.
//

import UIKit

/// A container navigation controller for a WebController u
///
/// Used to circumvent the WebKit error where attempting to select a file
/// for input results in the ViewController being dismissed
class WebViewNavigationController: UINavigationController {

    private weak var documentPicker: UIDocumentPickerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = AppGlobals.sakaiRed
        self.navigationBar.barStyle = .blackTranslucent
        self.toolbar.tintColor = AppGlobals.sakaiRed
        self.toolbar.barStyle = .blackTranslucent
    }

    public override func present(_ viewControllerToPresent: UIViewController,
                                 animated flag: Bool,
                                 completion: (() -> Void)? = nil) {
        if viewControllerToPresent is UIDocumentPickerViewController {
            self.documentPicker = viewControllerToPresent as? UIDocumentPickerViewController
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    override public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if self.presentedViewController == nil && self.documentPicker != nil {
            self.documentPicker = nil
        } else {
            super.dismiss(animated: flag, completion: completion)
        }
    }
}
