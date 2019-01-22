//
//  TabsController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/31/18.
//

import UIKit
import LNPopupController

/// The root tab bar controller for the application
class TabsController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        tabBar.tintColor = Palette.main.tabBarTintColor
        tabBar.isTranslucent = true
        tabBar.barStyle = Palette.main.barStyle
        tabBar.unselectedItemTintColor = Palette.main.tabBarUnselectedTintColor
        tabBar.backgroundColor = Palette.main.tabBarBackgroundColor
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let fromNav = selectedViewController as? UINavigationController
        let index = selectedIndex
        guard let itemIndex = tabBar.items?.index(of: item) else {
            return
        }
        let toNav = viewControllers?[itemIndex] as? UINavigationController
        if index == itemIndex && fromNav?.viewControllers.first is HomeViewController {
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
        } else if index != itemIndex && fromNav?.viewControllers.last is AssignmentPagesViewController {
            if toNav?.viewControllers.last is AssignmentPagesViewController {
                // If the tab being switched to also is presenting a
                // PagesController, the popup bar should NOT be dismissed
                return
            }
            dismissPopupBar(animated: true, completion: nil)
        }
    }
}
