//
//  RichTextEditorViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/14/19.
//

import UIKit
import RichEditorView
import LNPopupController

class RichTextEditorViewController: UIViewController {

    private lazy var editorView: RichTextSubmissionView = {
        let editor: RichTextSubmissionView = UIView.defaultAutoLayoutView()
        editor.textView.delegate = self
        return editor
    }()

    private lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()

    weak var delegate: RichTextEditorViewControllerDelegate?

    var placeholderText: String? {
        didSet {
            editorView.setTitlePlaceholder(text: placeholderText)
        }
    }

    var submissionTitle: String? {
        get {
            return editorView.titleField.text
        } set {
            editorView.titleField.text = newValue
        }
    }

    var html: String {
        get {
            return editorView.textView.html
        } set {
            editorView.textView.html = newValue
        }
    }

    var attributedContext: NSAttributedString? {
        get {
            return editorView.contextView.attributedText
        } set {
            editorView.setContext(withAttributedText: newValue)
        }
    }

    var needsTitleField: Bool = true {
        didSet {
            editorView.setNeedsTitle(to: needsTitleField)
        }
    }

    var needsContext: Bool = true {
        didSet {
            editorView.setNeedsContext(to: needsContext)
        }
    }

    var dismissAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        navigationController?.navigationBar.tintColor = Palette.main.toolBarColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                           target: self,
                                                           action: #selector(dismissController))
        editorView.textView.inputAccessoryView = toolbar
        toolbar.editor = editorView.textView

        view.addSubview(editorView)
        editorView.constrainToMargins(of: view, onSides: [.top, .bottom])
        editorView.constrainToEdges(of: view, onSides: [.left, .right])
    }

    @objc private func dismissController() {
        dismissAction?()
    }

    func resetHTML() {
        delegate?.editorController?(self, shouldSyncTextWithResult: { [weak self] html in
            guard let html = html else {
                return
            }
            self?.html = html
        })
    }
}

extension RichTextEditorViewController: RichEditorDelegate {

    func richEditorDidLoad(_ editor: RichEditorView) {
        editor.setEditorBackgroundColor(Palette.main.primaryBackgroundColor)
        editor.setEditorFontColor(Palette.main.primaryTextColor)
    }

    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if content == "" || content == nil {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}
