//
//  RichTextEditorViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/14/19.
//

import UIKit
import Toast_Swift
import Aztec
import WordPressEditor
import Gridicons
import MobileCoreServices
import SafariServices

class RichTextEditorViewController: UIViewController {

    private lazy var editorView: RichTextSubmissionView = {
        let editor: RichTextSubmissionView = UIView.defaultAutoLayoutView()
        let richTextView = editor.editorView.richTextView

        editor.editorView.htmlTextView.delegate = self
        
        richTextView.delegate = self
        richTextView.formattingDelegate = self
        richTextView.textAttachmentDelegate = self
        richTextView.keyboardDismissMode = .interactive

        let providers: [TextViewAttachmentImageProvider] = [
            GutenpackAttachmentRenderer(),
            SpecialTagAttachmentRenderer(),
            CommentAttachmentRenderer(font: RichTextSubmissionView.Constants.defaultContentFont),
            HTMLAttachmentRenderer(font: RichTextSubmissionView.Constants.defaultHtmlFont),
        ]
        for provider in providers {
            richTextView.registerAttachmentImageProvider(provider)
        }
        return editor
    }()

    private var richTextView: TextView {
        return editorView.editorView.richTextView
    }

    private lazy var formatBarController = FormatBarController(editorView: editorView.editorView, presenter: self)

    private var formatBar: Aztec.FormatBar {
        return formatBarController.formatBar
    }

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

    var html: String? {
        get {
            return editorView.editorView.getHTML()
        } set {
            guard let html = newValue else {
                return
            }
            editorView.editorView.setHTML(html)
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
        let saveButton = UIBarButtonItem(title: "Sync",
                                         style: .done,
                                         target: self,
                                         action: #selector(syncContent))
        navigationItem.rightBarButtonItem = saveButton

        richTextView.inputAccessoryView = formatBar
        editorView.editorView.htmlTextView.inputAccessoryView = formatBar
        formatBar.formatter = self

        view.addSubview(editorView)
        editorView.constrainToMargins(of: view, onSides: [.top, .bottom])
        editorView.constrainToEdges(of: view, onSides: [.left, .right])
    }

    override func viewDidAppear(_ animated: Bool) {
        richTextView.becomeFirstResponder()
    }

    func loadHTML() {
        html = ""
        delegate?.editorController?(self, loadTextWithResult: { [weak self] html in
            guard let html = html, html != "" else {
                self?.html = ""
                return
            }
            self?.html = html
            guard let endPosition = self?.richTextView.endOfDocument else {
                return
            }
            self?.richTextView.selectedTextRange = self?.richTextView.textRange(from: endPosition, to: endPosition)
        })
    }

    @objc private func dismissController() {
        dismissAction?()
    }

    @objc private func syncContent() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        editorView.editorView.richTextView.endEditing(true)
        editorView.titleField.endEditing(true)
        let group = DispatchGroup()
        var error = false
        group.enter()
        delegate?.editorController(self, shouldSaveBody: html, didSucceed: { [weak self] flag in
            self?.navigationItem.rightBarButtonItem?.isEnabled = true
            if !flag {
                error = true
            }
            group.leave()
        })

        group.enter()
        if let _ = delegate?.editorController?(self, shouldSaveTitle: submissionTitle, didSucceed: { flag in
            if !flag {
                error = true
            }
            group.leave()
        }) {
            // Do Nothing
        } else {
            group.leave()
        }

        let makeToast: (String) -> Void = { [weak self] msg in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self?.view.makeToast(msg)
            })
        }

        group.notify(queue: .main) {
            if !error {
                makeToast("Successfully synced your post! Head Over to the Web tab to Submit or Save")
            } else {
                makeToast("There was an error syncing your content")
            }
        }
    }
}

    

extension RichTextEditorViewController: FormatBarDelegate {
    func formatBarTouchesBegan(_ formatBar: FormatBar) {
        return
    }

    func formatBar(_ formatBar: FormatBar, didChangeOverflowState overflowState: FormatBarOverflowState) {
        return
    }
}

extension RichTextEditorViewController: TextViewFormattingDelegate {
    func textViewCommandToggledAStyle() {
        return
    }
}

extension RichTextEditorViewController: TextViewAttachmentDelegate {
    func textView(_ textView: TextView, attachment: NSTextAttachment, imageAt url: URL, onSuccess success: @escaping (UIImage) -> Void, onFailure failure: @escaping () -> Void) {
        return
    }

    func textView(_ textView: TextView, urlFor imageAttachment: ImageAttachment) -> URL? {
        return nil
    }

    func textView(_ textView: TextView, placeholderFor attachment: NSTextAttachment) -> UIImage {
        return UIImage()
    }

    func textView(_ textView: TextView, deletedAttachment attachment: MediaAttachment) {
        return
    }

    func textView(_ textView: TextView, selected attachment: NSTextAttachment, atPosition position: CGPoint) {
        return
    }

    func textView(_ textView: TextView, deselected attachment: NSTextAttachment, atPosition position: CGPoint) {
        return
    }
}

extension RichTextEditorViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        switch textView {
        case richTextView:
            formatBar.enabled = true
        case editorView.editorView.htmlTextView:
            formatBar.enabled = false

            // Disable the bar, except for the source code button
            let htmlButton = formatBar.items.first(where: { $0.identifier == FormattingIdentifier.sourcecode.rawValue })
            htmlButton?.isEnabled = true
        default: break
        }

        textView.inputAccessoryView = formatBar

        return true
    }

    func textView(_ textView: UITextView,
                         shouldInteractWith URL: URL,
                         in characterRange: NSRange) -> Bool {
        if !URL.absoluteString.contains("http") {
            return true
        }
        // For any Sakai url, open URL in custom WebViewController so
        // authentication state can be shared through cookies. Otherwise
        // open the link in a SFSafariViewController
        if URL.absoluteString.contains("sakai.rutgers.edu") {
            let webController = WebViewController()
            webController.setURL(url: URL)
            self.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(webController, animated: true)
            self.hidesBottomBarWhenPushed = false
            return false
        } else {
            let safariController = SFSafariViewController.defaultSafariController(url: URL)
            navigationController?.present(safariController, animated: true, completion: nil)
            return false
        }
    }
}
