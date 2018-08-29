//
//  AnnouncementPageView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/8/18.
//

import UIKit

class AnnouncementPageView: UIScrollView {

    var contentView: UIView!

    var titleLabel: InsetUILabel!
    var authorLabel: InsetUILabel!
    var dateLabel: InsetUILabel!
    var messageView: TappableTextView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addViews()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        contentView = UIView()

        titleLabel = InsetUILabel()
        titleLabel.titleLabel.numberOfLines = 0
        titleLabel.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.titleLabel.font = UIFont.boldSystemFont(ofSize: 18.5)
        titleLabel.layer.cornerRadius = 0

        authorLabel = InsetUILabel()
        authorLabel.titleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        authorLabel.layer.cornerRadius = 0
        authorLabel.backgroundColor = UIColor.white

        dateLabel = InsetUILabel()
        dateLabel.titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
        dateLabel.titleLabel.textAlignment = .right
        dateLabel.layer.cornerRadius = 0
        dateLabel.backgroundColor = UIColor.white

        messageView = TappableTextView(); messageView.isScrollEnabled = false
    }

    func addViews() {
        self.addSubview(contentView)

        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(authorLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(messageView)
    }

    func setConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true

        let margins = contentView.layoutMarginsGuide

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        messageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 75).isActive = true

        authorLabel.bottomAnchor.constraint(equalTo: messageView.topAnchor).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        authorLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.60).isActive = true

        dateLabel.topAnchor.constraint(equalTo: authorLabel.topAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: authorLabel.bottomAnchor).isActive = true

        messageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        messageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }

    func setMessage(attributedText: NSAttributedString?, resources: [NSAttributedString]?) {
        guard let text = attributedText else {
            return
        }
        let content = NSMutableAttributedString(attributedString: text)
        let contentRange = NSRange(location: 0, length: content.string.count)
        content.addAttribute(.font, value: UIFont.systemFont(ofSize: 16.0, weight: .regular), range: contentRange)
        if let attachmentString = getAttachments(resources: resources) {
            content.append(attachmentString)
        }
        messageView.attributedText = content
    }

    private func getAttachments(resources: [NSAttributedString]?) -> NSAttributedString? {
        guard let attachments = resources else {
            return nil
        }
        guard attachments.count > 0 else {
            return nil
        }
        let description = NSMutableAttributedString(string: "\n\nAttachments: \n\n")
        let descriptionRange = NSRange(location: 0, length: description.string.count)
        description.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18.0), range: descriptionRange)
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

    override func layoutSubviews() {
        super.layoutSubviews()
        // Set the content size of self (scrollView) to the size of the content view by using the maxY of the
        // attachmentsView (the farthest down point of all the content)
        let maxY = messageView.frame.maxY
        self.contentSize = CGSize(width: self.frame.width, height: maxY + 10)
    }
}
