//
//  UIViewControllerExtension.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/26/18.
//

import UIKit
import ReusableSource

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
        self.navigationController?.setToolbarHidden(true, animated: true)
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

    func addLoadingIndicator() -> (() -> ()) {
        let indicator = LoadingIndicator(view: view)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        let afterLoad = {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
        return afterLoad
    }

    func presentErrorAlert(error: Error) {
        let errorMessage = error.localizedDescription
        let alert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let alertController = UIAlertController(title: "ERROR", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(alert)
        self.present(alertController, animated: true, completion: nil)
    }
}
