//
//  TextViewDelegateExtension.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/27/18.
//

import UIKit
import SafariServices

// MARK: Web Content controller

// Ensure any Sakai link opened from a textView is routed to a WebController instead of Safari
extension UIViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.absoluteString.contains("sakai.rutgers.edu") {
            let webController = WebController()
            webController.setURL(url: URL)
            self.navigationController?.pushViewController(webController, animated: true)
            return false
        } else {
            let safariController = SFSafariViewController(url: URL)
            self.tabBarController?.present(safariController, animated: true, completion: nil)
            return false
        }
    }
}
