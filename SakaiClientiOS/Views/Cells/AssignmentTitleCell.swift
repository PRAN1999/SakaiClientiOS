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

    let titleLabel: InsetUILabel = {
        let titleLabel: InsetUILabel = UIView.defaultAutoLayoutView()
        titleLabel.titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        titleLabel.titleLabel.textColor = UIColor.lightText
        //titleLabel.textAlignment = .left
        titleLabel.layer.cornerRadius = 0
        titleLabel.layer.masksToBounds = false
        titleLabel.backgroundColor = UIColor.darkGray
        titleLabel.addBorder(toSide: .left, withColor: AppGlobals.sakaiRed, andThickness: 8.0)
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
        selectedBackgroundView = darkSelectedView()
        selectedBackgroundView?.addBorder(toSide: .left, withColor: AppGlobals.sakaiRed, andThickness: 8.0)

        contentView.addSubview(titleLabel)
    }

    private func setConstraints() {
        titleLabel.setLeftMargin(to: 5.0)

        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
    }

    func configure(_ item: [Assignment], at indexPath: IndexPath) {
        guard item.count > 0 else {
            return
        }
        let siteId = item[0].siteId
        let title = SakaiService.shared.siteTitleMap[siteId]
        titleLabel.titleLabel.text = title
    }
}
