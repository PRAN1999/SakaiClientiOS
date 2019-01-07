//
//  TextViewDelegateExtension.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/27/18.
//

import UIKit
import SafariServices
import LNPopupController

// MARK: Web Content controller

// Ensure any Sakai link opened from a textView is opened within the app
extension UIViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView,
                         shouldInteractWith URL: URL,
                         in characterRange: NSRange) -> Bool {
        // For any Sakai url, open URL in custom WebController so
        // authentication state can be shared through cookies. Otherwise
        // open the link in a SFSafariViewController
        if URL.absoluteString.contains("sakai.rutgers.edu") {
            let webController = WebController()
            webController.setURL(url: URL)
            self.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(webController, animated: true)
            self.hidesBottomBarWhenPushed = false
            return false
        } else {
            let safariController = SFSafariViewController.defaultSafariController(url: URL)
            tabBarController?.present(safariController, animated: true, completion: nil)
            return false
        }
    }
}
