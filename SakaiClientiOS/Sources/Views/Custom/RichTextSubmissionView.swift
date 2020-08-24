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
        static let defaultContentFont   = UIFont.systemFont(ofSize: 16)
        static let defaultHtmlFont      = UIFont.systemFont(ofSize: 24)
        static let defaultMissingImage  = UIImage.gridicon(.image)
        static let formatBarIconSize    = CGSize(width: 20.0, height: 30.0)
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
            defaultMissingImage: Constants.defaultMissingImage
        )

        editorView.clipsToBounds = false
        editorView.translatesAutoresizingMaskIntoConstraints = false

        editorView.richTextView.alwaysBounceVertical = true
        editorView.htmlTextView.alwaysBounceVertical = true

        editorView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return editorView
    }()

    lazy var bottomConstraint = editorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)

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

        addSubview(editorView)
    }

    private func setConstraints() {
        editorView.constrainToMargins(of: self, onSides: [.left, .right])
        editorView.constrainToEdge(of: self, onSide: .top)
        bottomConstraint.isActive = true
    }
}

extension RichTextSubmissionView: KeyboardUpdatable {
    func handleKeyboardNotification(notification: Notification) {
        self._handleKeyboardNotification(notification: notification)
    }
}
