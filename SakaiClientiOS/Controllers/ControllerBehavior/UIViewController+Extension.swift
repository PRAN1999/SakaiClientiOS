//
//  UIViewControllerExtension.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/26/18.
//

import UIKit

extension UIViewController {
    @objc func hideNavBar() {
        hideToolBar()
        guard let hidden = self.navigationController?.isNavigationBarHidden else {
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.isNavigationBarHidden = !hidden
        }
    }
    
    @objc func hideToolBar() {
        self.navigationController?.isToolbarHidden = true
    }
    
    func configureBarsForTaps(appearing: Bool) {
        self.navigationController?.hidesBarsOnTap = appearing
        self.tabBarController?.tabBar.isHidden = appearing
        if !appearing {
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    func configureNavigationTapRecognizer() {
        self.navigationController?.barHideOnTapGestureRecognizer.addTarget(self, action: #selector(hideToolBar))
    }
    
    func configureNavigationTapRecognizer(for tapRecognizer: UITapGestureRecognizer) {
        tapRecognizer.addTarget(self, action: #selector(hideNavBar))
    }
}
