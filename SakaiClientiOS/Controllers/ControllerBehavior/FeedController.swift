//
//  FeedController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/26/18.
//

import UIKit

@objc protocol FeedController {
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
    
    func addBarSwipeHider() {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.barHideOnSwipeGestureRecognizer.addTarget(self, action: #selector(swipeTarget))
    }
    
    func removeBarSwipeHider() {
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.barHideOnSwipeGestureRecognizer.removeTarget(self, action: #selector(swipeTarget))
    }
}
