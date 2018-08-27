//
//  UIViewControllerWebExtension.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/27/18.
//

import UIKit

extension UIViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let webController = WebController()
        webController.setURL(url: URL)
        self.navigationController?.pushViewController(webController, animated: true)
        return false
    }
}
