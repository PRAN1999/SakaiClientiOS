//
//  RichTextSubmissionView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/15/19.
//

import UIKit
import RichEditorView

class RichTextSubmissionView: UIView {

    let titleField: InsetTextField = {
        let field: InsetTextField = UIView.defaultAutoLayoutView()
        field.backgroundColor = Palette.main.secondaryBackgroundColor
        field.textColor = Palette.main.primaryTextColor
        field.font = UIFont.systemFont(ofSize: 25.0)
        return field
    }()

    let textView: RichEditorView = {
        let view: RichEditorView = UIView.defaultAutoLayoutView()
        view.backgroundColor = Palette.main.primaryBackgroundColor
        view.webView.isOpaque = false
        view.webView.backgroundColor = Palette.main.primaryBackgroundColor
        view.webView.scrollView.backgroundColor = Palette.main.primaryBackgroundColor
        return view
    }()

    let contextView: UITextView = {
        let view: UITextView = UIView.defaultAutoLayoutView()
        view.backgroundColor = Palette.main.secondaryBackgroundColor
        view.textColor = Palette.main.secondaryTextColor
        view.isEditable = false
        view.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return view
    }()

    private lazy var titleHeightConstraint = titleField.heightAnchor.constraint(equalToConstant: 0)
    private lazy var contextHeightConstraint = contextView.heightAnchor.constraint(equalToConstant: 0)
    lazy var bottomConstraint = contextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)

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
        addKeyboardObservers()

        addSubview(titleField)
        addSubview(textView)
        addSubview(contextView)
    }

    private func setConstraints() {
        titleField.constrainToEdges(of: self, onSides: [.left, .right, .top])
        titleField.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -10.0).isActive = true

        textView.constrainToMargins(of: self, onSides: [.left, .right])
        textView.bottomAnchor.constraint(equalTo: contextView.topAnchor).isActive = true

        contextView.constrainToEdges(of: self, onSides: [.left, .right])
        contextView.heightAnchor.constraint(lessThanOrEqualToConstant: 150.0).isActive = true
        bottomConstraint.isActive = true
    }

    func setNeedsTitle(to flag: Bool) {
        if flag {
            titleHeightConstraint.isActive = false
        } else {
            titleHeightConstraint.isActive = true
        }
        setNeedsLayout()
    }

    func setNeedsContext(to flag: Bool) {
        if flag {
            contextHeightConstraint.isActive = false
        } else {
            contextHeightConstraint.isActive = true
        }
        setNeedsLayout()
    }

    func setTitlePlaceholder(text: String?) {
        guard let text = text else {
            return
        }
        var attributes: [NSAttributedStringKey: Any] = [:]
        attributes.updateValue(Palette.main.secondaryTextColor.withAlphaComponent(0.2),
                               forKey: .foregroundColor)
        attributes.updateValue(UIFont.systemFont(ofSize: 25.0), forKey: .font)
        titleField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: attributes
        )
    }

    func setContext(withAttributedText text: NSAttributedString?) {
        guard let text = text else {
            return
        }
        contextView.attributedText = text
    }
}

extension RichTextSubmissionView: KeyboardUpdatable {
    func handleKeyboardNotification(notification: Notification) {
        self._handleKeyboardNotification(notification: notification)
    }
}
