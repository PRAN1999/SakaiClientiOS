//
//  KeyboardUpdater.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/15/19.
//

import Foundation
import UIKit

@objc protocol KeyboardUpdatable {
    var bottomConstraint: NSLayoutConstraint { get }

    func handleKeyboardNotification(notification: Notification)
}

extension KeyboardUpdatable where Self: UIView {

    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardNotification(notification:)),
            name: .UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardNotification(notification:)),
            name: .UIKeyboardWillHide,
            object: nil
        )
    }

    func _handleKeyboardNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        // If the keyboard is showing, the messagebar needs to travel up
        // with it and if it is hidden, the messagebar should slide back
        // down. Additionally, if the keyboard is going to show, the chat
        // needs to scroll down to the latest messages.
        let cgRect = keyboardFrame.cgRectValue
        let isKeyboardShowing = notification.name == .UIKeyboardWillShow
        bottomConstraint.constant = isKeyboardShowing ? -cgRect.height : 0

        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { [weak self] in
            self?.layoutIfNeeded()
        }, completion: nil)
    }
}
