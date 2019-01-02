//
//  MessageBar.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/27/18.
//

import UIKit

/// A message bar for a chat interface
class MessageBar: UIView {
    
    let inputField: ChatTextView = {
        let inputField: ChatTextView = UIView.defaultAutoLayoutView()
        inputField.isScrollEnabled = false
        inputField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        inputField.textColor = Palette.main.highlightColor
        inputField.tintColor = Palette.main.highlightColor
        inputField.font = UIFont.systemFont(ofSize: 16)
        inputField.backgroundColor = Palette.main.secondaryBackgroundColor
        inputField.layer.cornerRadius = 5
        inputField.layer.borderWidth = 1
        inputField.layer.borderColor = Palette.main.borderColor.cgColor
        return inputField
    }()

    let sendButton: UIButton = {
        let sendButton = UIButton(type: .contactAdd)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sendButton.tintColor = Palette.main.highlightColor
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        return sendButton
    }()

    var shouldSetConstraints = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Palette.main.primaryBackgroundColor

        addSubview(inputField)
        addSubview(sendButton)
    }

    private func setConstraints() {
        let margins = layoutMarginsGuide

        inputField.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        inputField.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        inputField.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        inputField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor,
                                             constant: -5.0).isActive = true
        inputField.widthAnchor.constraint(equalTo: widthAnchor,
                                          multiplier: 0.80).isActive = true

        sendButton.topAnchor.constraint(equalTo: inputField.topAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: inputField.bottomAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5.0).isActive = true
    }
}
