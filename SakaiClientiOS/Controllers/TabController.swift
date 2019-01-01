//
//  TabController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/31/18.
//

import UIKit
import LNPopupController

class TabController: UITabBarController {

    weak var popupController: UIViewController?
    var shouldOpenPopup = false

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if popupController != nil && (viewControllerToPresent is UIDocumentPickerViewController ||
            viewControllerToPresent is UIImagePickerController) {
            shouldOpenPopup = true
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
