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

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = Palette.main.tabBarTintColor
        tabBar.isTranslucent = true
        tabBar.barStyle = Palette.main.barStyle
        tabBar.unselectedItemTintColor = Palette.main.tabBarUnselectedTintColor
        tabBar.backgroundColor = Palette.main.tabBarBackgroundColor
        // Do any additional setup after loading the view.
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if popupController != nil && (viewControllerToPresent is UIDocumentPickerViewController ||
            viewControllerToPresent is UIImagePickerController) {
            shouldOpenPopup = true
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
