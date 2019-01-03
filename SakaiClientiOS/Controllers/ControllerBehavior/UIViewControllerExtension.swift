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
