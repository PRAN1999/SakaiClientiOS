//
//  FeedController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/26/18.
//

import UIKit

/// Describes UI behavior for views that present a feed of data
///
/// Used for AnnouncementController and SiteAnnouncementController
@objc protocol FeedController {

    /// Action to execute when scroll gesture is recognized
    ///
    /// For most implementations, calling
    ///
    ///     func setTabBarVisibility()
    ///
    /// will be sufficient to remove the tab bar and nav bar when scrolling
    @objc func swipeTarget()
}

extension FeedController where Self: UIViewController {
    func setTabBarVisibility() {
        guard let hidden = self.navigationController?.isNavigationBarHidden else {
            return
        }
        if hidden {
            animateTabBar(to: true)
        } else {
            animateTabBar(to: false)
        }
    }
    
    func animateTabBar(to visibility: Bool) {
        UIView.animate(withDuration: 0.6) {
            self.tabBarController?.tabBar.isHidden = visibility
        }
    }
    
    /// Configure ViewController on appearance
    func addBarSwipeHider() {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.barHideOnSwipeGestureRecognizer.addTarget(self, action: #selector(swipeTarget))
    }
    
    /// Remove recognizers when transitioning from FeedController
    func removeBarSwipeHider() {
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.barHideOnSwipeGestureRecognizer.removeTarget(self, action: #selector(swipeTarget))
    }
}
