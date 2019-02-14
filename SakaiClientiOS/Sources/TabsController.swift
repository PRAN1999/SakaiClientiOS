//
//  TabsController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/31/18.
//

import UIKit

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
        if index == itemIndex && fromNav?.viewControllers.first is HomeViewController {
            // If a user taps on Home to return to the root
            // Home controller, a presented PagesController will not have
            // a reference to the navigationController in viewWillDisappear
            // and the pop gesture must be manually enabled
            fromNav?.popToRootViewController(animated: true)
            fromNav?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}
