//
//  SiteCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/27/18.
//

import UIKit
import ReusableSource

/// The Tableview Cell to display Site titles
class SiteCell: UITableViewCell, ConfigurableCell {
    typealias T = Site

    let titleLabel: UILabel = {
        let titleLabel: UILabel = UIView.defaultAutoLayoutView()
        titleLabel.textColor = Palette.main.secondaryTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 20.0,
                                            weight: UIFont.Weight.light)
        return titleLabel
    }()

    let iconLabel: UILabel = {
        let iconLabel: UILabel = UIView.defaultAutoLayoutView()
        iconLabel.font = UIFont(name: AppIcons.siteFont, size: 30.0)
        iconLabel.textColor = Palette.main.primaryTextColor
        iconLabel.textAlignment = .left
        return iconLabel
    }()

    private lazy var iconVisibleConstraint: NSLayoutConstraint = {
        let margins = contentView.layoutMarginsGuide
        return iconLabel.widthAnchor.constraint(equalToConstant: 30)
    }()
    private lazy var iconHiddenConstraint: NSLayoutConstraint = {
        let margins = contentView.layoutMarginsGuide
        return iconLabel.widthAnchor.constraint(equalTo: margins.widthAnchor,
                                                multiplier: 0)
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        accessoryType = .disclosureIndicator

        backgroundColor = Palette.main.primaryBackgroundColor
        selectedBackgroundView = selectedView()
        selectedBackgroundView?.addBorder(toSide: .left,
                                          withColor: Palette.main.highlightColor,
                                          andThickness: 5.0)

        backgroundView = defaultBackgroundView()
        backgroundView?.addBorder(toSide: .left,
                                  withColor: Palette.main.highlightColor,
                                  andThickness: 5.0)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconLabel)
    }

    private func setConstraints() {
        iconLabel.constrainToMargins(of: contentView,
                                     onSides: [.bottom, .top, .left])
        titleLabel.constrainToMargins(of: contentView,
                                      onSides: [.bottom, .top, .right])
        iconLabel.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor,
                                            constant: -5).isActive = true
    }

    func configure(_ item: Site, at indexPath: IndexPath) {
        iconVisibleConstraint.isActive = false
        iconHiddenConstraint.isActive = false
        if let subjectCode = item.subjectCode,
           let icon = AppIcons.codeToIcon[subjectCode] {
            iconLabel.text = icon
            iconVisibleConstraint.isActive = true
        } else {
            iconLabel.text = nil
            iconHiddenConstraint.isActive = true
        }
        titleLabel.text = item.title
    }
}
