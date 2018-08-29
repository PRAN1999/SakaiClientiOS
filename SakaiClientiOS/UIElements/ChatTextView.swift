//
//  ChatTextView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/27/18.
//

import UIKit
import ReusableSource

class ChatTextView: UITextView {
    // swiftlint:disable weak_delegate
    var chatDelegate = Delegated<Void, Void>()

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            chatDelegate.call()
        }
        return true
    }
}
