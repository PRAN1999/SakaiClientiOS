//
//  AnnouncmentCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/30/18.
//

import UIKit
import ReusableSource

/// The UITableViewCell to display an Announcement object
class AnnouncementCell: UITableViewCell, ConfigurableCell {
    typealias T = Announcement

    let authorLabel: UILabel = {
        let authorLabel: UILabel = UIView.defaultAutoLayoutView()
        authorLabel.textColor = UIColor.black
        authorLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.bold)
        return authorLabel
    }()

    let titleLabel: UILabel = {
        let titleLabel: UILabel = UIView.defaultAutoLayoutView()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.medium)
        return titleLabel
    }()

    let contentLabel: UILabel = UIView.defaultAutoLayoutView()

    let dateLabel: UILabel = {
        let dateLabel: UILabel = UIView.defaultAutoLayoutView()
        dateLabel.textColor = UIColor.darkGray
        dateLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.medium)
        dateLabel.textAlignment = .right
        return dateLabel
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(authorLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
    }

    private func setConstraints() {
        let margins = contentView.layoutMarginsGuide

        authorLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        authorLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        authorLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -2.0).isActive = true
        authorLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.75).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentLabel.topAnchor, constant: -2.0).isActive = true

        contentLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true

        dateLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10.0).isActive = true
    }

    /// Configure the AnnouncementCell with a Announcement object
    ///
    /// - Parameters:
    ///   - item: The Announcement to be used as the model for the cell
    ///   - indexPath: The indexPath at which the AnnouncementCell will be displayed in the UITableView
    func configure(_ item: Announcement, at indexPath: IndexPath) {
        authorLabel.text = item.author
        titleLabel.text = item.title

        if let content = item.attributedContent {
            let mutableContent = NSMutableAttributedString(attributedString: content)
            let contentRange = NSRange(location: 0, length: content.string.count)
            mutableContent.addAttribute(.font,
                                        value: UIFont.systemFont(ofSize: 14.0,
                                                                 weight: UIFont.Weight.light),
                                        range: contentRange)
            contentLabel.attributedText = mutableContent
        }
        dateLabel.text = item.dateString
    }
}
