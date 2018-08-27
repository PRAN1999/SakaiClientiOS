//
//  WebNavigationController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/11/18.
//

import UIKit

class WebViewNavigationController: UINavigationController {

    private weak var documentPicker: UIDocumentPickerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = AppGlobals.SAKAI_RED
        self.navigationBar.barStyle = .blackTranslucent
        self.toolbar.tintColor = AppGlobals.SAKAI_RED
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
