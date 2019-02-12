//
//  PageView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/18/18.
//

import UIKit

/// A full page scrollview
class PageView<PageType: UIScrollView>: UIView {

    let scrollView: PageType = UIView.defaultAutoLayoutView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(scrollView)
    }

    private func setConstraints() {
        //scrollView.constrainToMargins(of: self, onSides: [.top, .bottom])
        scrollView.constrainToEdges(of: self, onSides: [.top, .bottom, .left, .right])
    }

    static func getInstructionsString(attributedText: NSAttributedString?) -> NSMutableAttributedString? {
        guard let text = attributedText else {
            return nil
        }
        let instructions = NSMutableAttributedString(attributedString: text)
        let instructionRange = NSRange(location: 0, length: instructions.string.count)

        instructions.addAttribute(.font,
                                  value: UIFont.systemFont(ofSize: 16.0, weight: .regular),
                                  range: instructionRange)
        instructions.addAttribute(.foregroundColor,
                                  value: Palette.main.secondaryTextColor,
                                  range: instructionRange)

        let description = NSMutableAttributedString(string: "Instructions: \n\n")
        let descriptionRange = NSRange(location: 0, length: description.string.count)

        description.addAttribute(.font,
                                 value: UIFont.boldSystemFont(ofSize: 18.0),
                                 range: descriptionRange)
        description.addAttribute(.foregroundColor,
                                 value: Palette.main.primaryTextColor,
                                 range: descriptionRange)
        description.append(instructions)
        return description
    }

    static func getAttachmentsString(resources: [NSAttributedString]?) -> NSMutableAttributedString? {
        guard let attachments = resources else {
            return nil
        }

        let description = NSMutableAttributedString(string: "\n\n\nAttachments: \n\n")
        let descriptionRange = NSRange(location: 0, length: description.string.count)

        description.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18.0), range: descriptionRange)
        description.addAttribute(.foregroundColor, value: Palette.main.primaryTextColor, range: descriptionRange)

        for attachment in attachments {
            let mutableAttachment = NSMutableAttributedString(attributedString: attachment)
            let mutableAttachmentRange = NSRange(location: 0, length: mutableAttachment.string.count)
            mutableAttachment.addAttribute(.font,
                                           value: UIFont.systemFont(ofSize: 16.0, weight: .regular),
                                           range: mutableAttachmentRange)
            description.append(mutableAttachment)
            let spaceString = "\n\n"
            description.append(NSAttributedString(string: spaceString))
        }
        return description
    }
}
