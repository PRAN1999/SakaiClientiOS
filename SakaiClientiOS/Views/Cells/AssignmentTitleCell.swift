//
//  AssignmentTitleCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 11/8/18.
//

import Foundation
import UIKit
import ReusableSource

class AssignmentTitleCell: UITableViewCell, ConfigurableCell {
    typealias T = [Assignment]

    let titleLabel: IconLabel = {
        let titleLabel: IconLabel = UIView.defaultAutoLayoutView()
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        titleLabel.textColor = Palette.main.secondaryTextColor
        titleLabel.layer.cornerRadius = 0
        titleLabel.layer.masksToBounds = false
        titleLabel.iconLabel.textColor = Palette.main.primaryTextColor
        titleLabel.addBorder(toSide: .left, withColor: Palette.main.highlightColor, andThickness: 5.0)
        return titleLabel
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
        backgroundColor = Palette.main.primaryBackgroundColor
        selectedBackgroundView = selectedView()
        selectedBackgroundView?.addBorder(toSide: .left,
                                          withColor: Palette.main.highlightColor,
                                          andThickness: 5.0)
        contentView.addSubview(titleLabel)
    }

    private func setConstraints() {
        titleLabel.setLeftMargin(to: 5.0)

        titleLabel.constrainToEdges(of: contentView)

        let heightConstraint = titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        heightConstraint.priority = UILayoutPriority(999)
        heightConstraint.isActive = true
    }

    func configure(_ item: [Assignment], at indexPath: IndexPath) {
        guard item.count > 0 else {
            return
        }
        let title = item[0].siteTitle
        titleLabel.text = title
        if let code = item[0].subjectCode {
            titleLabel.iconText = AppIcons.codeToIcon[code]
        } else {
            titleLabel.iconText = nil
        }
    }
}
