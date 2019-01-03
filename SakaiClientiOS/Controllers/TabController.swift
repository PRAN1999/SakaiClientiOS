//
//  TabController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/31/18.
//

import UIKit
import LNPopupController

class TabController: UITabBarController, UITabBarControllerDelegate {

    weak var popupController: UIViewController?
    var shouldOpenPopup = false
    var isMovingToNewTabFromPages = false

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.tintColor = Palette.main.tabBarTintColor
        tabBar.isTranslucent = true
        tabBar.barStyle = Palette.main.barStyle
        tabBar.unselectedItemTintColor = Palette.main.tabBarUnselectedTintColor
        tabBar.backgroundColor = Palette.main.tabBarBackgroundColor
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if popupController != nil && (viewControllerToPresent is UIDocumentPickerViewController ||
            viewControllerToPresent is UIImagePickerController) {
            shouldOpenPopup = true
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let fromNav = selectedViewController as? UINavigationController
        let index = selectedIndex
        guard let itemIndex = tabBar.items?.index(of: item) else {
            return
        }
        let toNav = viewControllers?[itemIndex] as? UINavigationController
        if index == itemIndex && fromNav?.viewControllers.first is HomeController {
            dismissPopupBar(animated: true, completion: nil)
            fromNav?.popToRootViewController(animated: true)
            fromNav?.interactivePopGestureRecognizer?.isEnabled = true
        } else if index != itemIndex && fromNav?.viewControllers.last is PagesController {
            isMovingToNewTabFromPages = true
            if toNav?.viewControllers.last is PagesController {
                return
            }
            dismissPopupBar(animated: true, completion: nil)
        }
    }
}
