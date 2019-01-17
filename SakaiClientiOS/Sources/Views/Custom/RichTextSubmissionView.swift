//
//  RichTextSubmissionView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/15/19.
//

import UIKit
import Aztec
import Gridicons

class RichTextSubmissionView: UIView {

    struct Constants {
        static let defaultContentFont   = UIFont.systemFont(ofSize: 14)
        static let defaultHtmlFont      = UIFont.systemFont(ofSize: 24)
        static let defaultMissingImage  = Gridicon.iconOfType(.image)
        static let formatBarIconSize    = CGSize(width: 20.0, height: 20.0)
        static let headers              = [Header.HeaderType.none, .h1, .h2, .h3, .h4, .h5, .h6]
        static let lists                = [TextList.Style.unordered, .ordered]
        static let titleInsets          = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }

    private(set) lazy var editorView: Aztec.EditorView = {
        let defaultHTMLFont: UIFont

        if #available(iOS 11, *) {
            defaultHTMLFont = UIFontMetrics.default.scaledFont(for: Constants.defaultContentFont)
        } else {
            defaultHTMLFont = Constants.defaultContentFont
        }

        let editorView = Aztec.EditorView(
            defaultFont: Constants.defaultContentFont,
            defaultHTMLFont: defaultHTMLFont,
            defaultParagraphStyle: .default,
            defaultMissingImage: Constants.defaultMissingImage)

        editorView.clipsToBounds = false
        editorView.translatesAutoresizingMaskIntoConstraints = false

        return editorView
    }()

    let titleField: InsetTextField = {
        let field: InsetTextField = UIView.defaultAutoLayoutView()
        field.backgroundColor = Palette.main.secondaryBackgroundColor
        field.textColor = Palette.main.primaryTextColor
        field.font = UIFont.systemFont(ofSize: 25.0)
        return field
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
        backgroundColor = UIColor.white
        addKeyboardObservers()

        addSubview(titleField)
        addSubview(editorView)
        addSubview(contextView)
    }

    private func setConstraints() {
        titleField.constrainToEdges(of: self, onSides: [.left, .right, .top])
        titleField.bottomAnchor.constraint(equalTo: editorView.topAnchor, constant: -10.0).isActive = true

        editorView.constrainToMargins(of: self, onSides: [.left, .right])
        editorView.bottomAnchor.constraint(equalTo: contextView.topAnchor, constant: -10.0).isActive = true

        contextView.constrainToEdges(of: self, onSides: [.left, .right])
        contextView.heightAnchor.constraint(equalToConstant: 120.0).isActive = true
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
