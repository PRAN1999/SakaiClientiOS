//
//  NavigationController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/2/19.
//

import UIKit

/// The Navigation Controller subclass for all navigation controllers in the
/// app
class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = Palette.main.navigationTintColor
        navigationBar.barStyle = Palette.main.barStyle
        navigationBar.barTintColor = Palette.main.navigationBackgroundColor
        navigationBar.titleTextAttributes?.updateValue(Palette.main.navigationTitleColor,
                                                       forKey: .foregroundColor)
        navigationBar.isTranslucent = false

        toolbar.tintColor = Palette.main.toolBarColor
        toolbar.barStyle = Palette.main.barStyle
        toolbar.barTintColor = Palette.main.tabBarBackgroundColor

        interactivePopGestureRecognizer?.delegate = self
        delegate = self
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // Use NavigationAnimatable protocol to allow ViewControllers to define
        // their own transitions while preserving existing transitions for
        // all other controllers in the stack
        if let origin = fromVC as? NavigationAnimatable {
            switch operation {
            case .none:
                return nil
            case .push:
                return origin.animationControllerForPush(to: toVC)
            case .pop:
                return origin.animationControllerForPop(to: toVC)
            }
        }
        return nil
    }

    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // Allow different animations to define their interaction status if
        // needed using Interactable protocol
        if let interactable = animationController as? Interactable {
            return interactable.interactionController
        }
        return nil
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Determines if "swipe-to-go-back" gesture recognizer should start
        // By manually setting UINavigationControllerDelegate, pop gesture
        // recognizer is disabled so this enables it again.
        return viewControllers.count > 1
    }
}
