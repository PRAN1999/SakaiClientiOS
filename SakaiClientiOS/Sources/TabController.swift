//
//  TabController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/31/18.
//

import UIKit
import LNPopupController

/// The root tab bar controller for the application
class TabController: UITabBarController, UITabBarControllerDelegate {

    /// Whenever presenting a popup bar, this value should be set to inform
    /// the tabBarController that it is currently presenting a popup
    weak var popupController: UIViewController?

    /// Determines if the popup should be opened when a view controller is
    /// presenting the popup bar.
    ///
    /// See PagesController
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

    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        if popupController != nil &&
            (viewControllerToPresent is UIDocumentPickerViewController ||
            viewControllerToPresent is UIImagePickerController) {
            // If a Document or Image Picker is being shown, a WebKit bug
            // will cause the popupController to be closed. So, once a
            // document or image has been selected, the popup controller
            // should reopen once the picker controller is dismissed. This
            // property will be used in PagesController
            shouldOpenPopup = true
        }
        super.present(viewControllerToPresent,
                      animated: flag,
                      completion: completion)
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let fromNav = selectedViewController as? UINavigationController
        let index = selectedIndex
        guard let itemIndex = tabBar.items?.index(of: item) else {
            return
        }
        let toNav = viewControllers?[itemIndex] as? UINavigationController
        if index == itemIndex &&
            fromNav?.viewControllers.first is HomeController {
            // The PagesController is the only screen in the app that will
            // present a popup bar. It can be accessed through the Home or
            // Assignment tabs. If a user taps on Home to return to the root
            // Home controller, a presented PagesController will not have
            // a reference to the tabBarController or navigationController
            // in viewWillDisappear and so the popup bar must be dismissed
            // here and the pop gesture must be manually enabled
            dismissPopupBar(animated: true, completion: nil)
            fromNav?.popToRootViewController(animated: true)
            fromNav?.interactivePopGestureRecognizer?.isEnabled = true
        } else if index != itemIndex &&
            fromNav?.viewControllers.last is PagesController {
            // If the user is moving from a PagesController to another tab
            // (i.e. Assignments tab to Gradebook), the popup bar's behavior
            // will be defined here and not in viewWillDisappear of the
            // PagesController instance, where this flag is used.
            isMovingToNewTabFromPages = true
            if toNav?.viewControllers.last is PagesController {
                // If the tab being switched to also is presenting a
                // PagesController, the popup bar should NOT be dismissed
                return
            }
            dismissPopupBar(animated: true, completion: nil)
        }
    }
}
