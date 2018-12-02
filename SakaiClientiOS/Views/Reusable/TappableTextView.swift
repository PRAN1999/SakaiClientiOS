//
//  TappableTextView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/19/18.
//

import UIKit

/// A TextView that deselects any text when it is tapped
class TappableTextView: UITextView {

    let tapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(deselectText))
        return tapRecognizer
    }()

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        isEditable = false
        isSelectable = true

        addGestureRecognizer(tapRecognizer)
    }

    @objc func deselectText() {
        selectedTextRange = nil
    }
}
