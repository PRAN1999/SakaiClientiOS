//
//  AnnouncementPageView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/8/18.
//

import UIKit

/// The view to display an Announcement in a full page
class AnnouncementPageView: UIScrollView {

    let contentView: UIView = UIView.defaultAutoLayoutView()

    let titleLabel: InsetUILabel = {
        let titleLabel: InsetUILabel = UIView.defaultAutoLayoutView()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.5)
        titleLabel.textColor = Palette.main.secondaryTextColor
        titleLabel.backgroundColor = Palette.main.secondaryBackgroundColor.color(withTransparency: 0.5)
        titleLabel.addBorder(toSide: .bottom, withColor: Palette.main.highlightColor, andThickness: 2.0)
        return titleLabel
    }()

    let authorLabel: InsetUILabel = {
        let authorLabel: InsetUILabel = UIView.defaultAutoLayoutView()
        authorLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        authorLabel.layer.cornerRadius = 0
        authorLabel.backgroundColor = Palette.main.primaryBackgroundColor
        authorLabel.textColor = Palette.main.primaryTextColor
        return authorLabel
    }()

    let dateLabel: InsetUILabel = {
        let dateLabel: InsetUILabel = UIView.defaultAutoLayoutView()
        dateLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
        dateLabel.textAlignment = .right
        dateLabel.layer.cornerRadius = 0
        dateLabel.backgroundColor = Palette.main.primaryBackgroundColor
        dateLabel.textColor = Palette.main.secondaryTextColor
        return dateLabel
    }()

    let messageView: TappableTextView = {
        let messageView: TappableTextView = UIView.defaultAutoLayoutView()
        messageView.isScrollEnabled = false
        messageView.backgroundColor = Palette.main.primaryBackgroundColor
        messageView.tintColor = Palette.main.linkColor
        return messageView
    }()

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
        addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(messageView)
    }

    private func setConstraints() {
        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        let margins = contentView.layoutMarginsGuide

        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor, constant: -5.0).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 75).isActive = true

        authorLabel.bottomAnchor.constraint(equalTo: messageView.topAnchor).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        authorLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                           multiplier: 0.60).isActive = true

        dateLabel.topAnchor.constraint(equalTo: authorLabel.topAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: authorLabel.bottomAnchor).isActive = true

        messageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        messageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Set the content size of self (scrollView) to the size of the content view by using the maxY of the
        // attachmentsView (the farthest down point of all the content)
        let maxY = messageView.frame.maxY
        contentSize = CGSize(width: self.frame.width, height: maxY)
    }
}

extension AnnouncementPageView {
    
    func configure(announcement: Announcement) {
        titleLabel.titleLabel.text = announcement.title
        authorLabel.titleLabel.text = announcement.author
        dateLabel.titleLabel.text = announcement.dateString
        let resourceStrings = announcement.attachments?.map { $0.toAttributedString() }
        setMessage(attributedText: announcement.attributedContent, resources: resourceStrings)
    }

    private func setMessage(attributedText: NSAttributedString?, resources: [NSAttributedString]?) {
        guard let text = attributedText else {
            return
        }
        let content = NSMutableAttributedString(attributedString: text)
        let contentRange = NSRange(location: 0, length: content.string.count)
        content.addAttribute(.font,
                             value: UIFont.systemFont(ofSize: 16.0, weight: .regular),
                             range: contentRange)
        content.addAttribute(.foregroundColor, value: Palette.main.secondaryTextColor, range: contentRange)
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
