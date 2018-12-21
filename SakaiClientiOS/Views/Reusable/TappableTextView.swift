//
//  TappableTextView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/19/18.
//

import UIKit

/// A TextView that deselects any text when it is tapped
class TappableTextView: UITextView {

    let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: nil, action: nil)

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        isEditable = false
        isSelectable = true

        tapRecognizer.addTarget(self, action: #selector(deselectText))

        addGestureRecognizer(tapRecognizer)
    }

    @objc private func deselectText() {
        selectedTextRange = nil
    }
}
