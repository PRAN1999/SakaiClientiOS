//
//  UIViewControllerExtension.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/26/18.
//

import UIKit
import ReusableSource


// MARK: - Utility methods

extension UIViewController {
    @objc func hideNavBar() {
        hideToolBar()
        guard let hidden = navigationController?.isNavigationBarHidden else {
            return
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.navigationController?.isNavigationBarHidden = !hidden
        }
    }
    
    @objc func hideToolBar() {
        navigationController?.isToolbarHidden = true
    }
    
    func configureBarsForTaps(appearing: Bool) {
        navigationController?.hidesBarsOnTap = appearing
        tabBarController?.tabBar.isHidden = appearing
        navigationController?.setToolbarHidden(true, animated: true)
        if !appearing {
            navigationController?.isNavigationBarHidden = false
        }
    }
    
    func configureNavigationTapRecognizer() {
        navigationController?.barHideOnTapGestureRecognizer.addTarget(self, action: #selector(hideToolBar))
    }
    
    func configureNavigationTapRecognizer(for tapRecognizer: UITapGestureRecognizer) {
        tapRecognizer.addTarget(self, action: #selector(hideNavBar))
    }

    /// Presents an error message to the screen in a UIAlert
    ///
    /// - Parameter error: the error to show
    func presentErrorAlert(error: Error) {
        let errorMessage = error.localizedDescription
        let alert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let alertController = UIAlertController(title: "ERROR", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(alert)
        present(alertController, animated: true, completion: nil)
    }
}
