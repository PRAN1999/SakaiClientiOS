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
        authorLabel.textColor = Palette.main.primaryTextColor
        authorLabel.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.bold)
        authorLabel.textAlignment = .left
        return authorLabel
    }()

    let iconLabel: UILabel = {
        let iconLabel: UILabel = UIView.defaultAutoLayoutView()
        iconLabel.font = UIFont(name: AppIcons.siteFont, size: 30.0)
        iconLabel.textColor = Palette.main.primaryTextColor
        return iconLabel
    }()

    let titleLabel: UILabel = {
        let titleLabel: UILabel = UIView.defaultAutoLayoutView()
        titleLabel.textColor = Palette.main.secondaryTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.medium)
        return titleLabel
    }()

    let contentLabel: UILabel = UIView.defaultAutoLayoutView()

    let dateIcon: UILabel = {
        let dateIcon: UILabel = UIView.defaultAutoLayoutView()
        dateIcon.font = UIFont(name: AppIcons.generalIconFont, size: 15.0)
        dateIcon.text = AppIcons.dateIcon
        dateIcon.textColor = Palette.main.tertiaryBackgroundColor
        dateIcon.textAlignment = .right
        return dateIcon
    }()

    let dateLabel: UILabel = {
        let dateLabel: UILabel = UIView.defaultAutoLayoutView()
        dateLabel.textColor = Palette.main.secondaryTextColor
        dateLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.medium)
        dateLabel.textAlignment = .right
        dateLabel.adjustsFontSizeToFitWidth = true
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
        //selectionStyle = .gray
        selectedBackgroundView = selectedView()
        backgroundColor = Palette.main.primaryBackgroundColor

        contentView.addSubview(authorLabel)
        contentView.addSubview(iconLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateIcon)
        contentView.addSubview(dateLabel)
    }

    private func setConstraints() {
        let margins = contentView.layoutMarginsGuide

        authorLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: dateIcon.leadingAnchor, constant: -5.0).isActive = true
        authorLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        authorLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -2.0).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentLabel.topAnchor, constant: -2.0).isActive = true

        contentLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true

        iconLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        iconLabel.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        iconLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.12).isActive = true

        dateIcon.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        dateIcon.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        dateIcon.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: 0.0).isActive = true
        dateIcon.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.05).isActive = true

        dateLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10.0).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.23).isActive = true
    }

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
            mutableContent.addAttribute(.foregroundColor,
                                        value: Palette.main.secondaryTextColor,
                                        range: contentRange)
            contentLabel.attributedText = mutableContent
        }
        dateLabel.text = item.dateString
        if let code = item.subjectCode {
            iconLabel.text = AppIcons.codeToIcon[code]
        } else {
            iconLabel.text = nil
        }
    }
}
