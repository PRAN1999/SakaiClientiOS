//
//  AssignmentTableCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/10/18.
//

import UIKit
import ReusableSource

/// A TableViewCell to represent a group of Assignment objects, either for a specific class or for an entire Term
class AssignmentTableCell: UITableViewCell, ConfigurableCell {
    typealias T = [Assignment]

    let titleLabel: IconLabel = {
        let titleLabel: IconLabel = UIView.defaultAutoLayoutView()
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        titleLabel.textColor = Palette.main.secondaryTextColor
        titleLabel.backgroundColor = Palette.main.primaryBackgroundColor
        titleLabel.layer.cornerRadius = 0
        titleLabel.layer.masksToBounds = false
        titleLabel.addBorder(toSide: .left, withColor: Palette.main.highlightColor, andThickness: 5.0)
        return titleLabel
    }()

    let iconLabel: UILabel = {
        let iconLabel: UILabel = UIView.defaultAutoLayoutView()
        iconLabel.font = UIFont(name: AppIcons.siteFont, size: 25.0)
        iconLabel.textColor = Palette.main.primaryTextColor
        return iconLabel
    }()

    let collectionView: UICollectionView = {
        let layout = HorizontalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Palette.main.primaryBackgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.indicatorStyle = Palette.main.scrollViewIndicatorStyle
        return collectionView
    }()

    private(set) lazy var manager: AssignmentCollectionManager = AssignmentCollectionManager(collectionView: collectionView)

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

        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(iconLabel)
    }

    private func setConstraints() {
        let margins = contentView.layoutMarginsGuide

        titleLabel.setLeftMargin(to: 5.0)

        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10.0).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true

        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10.0).isActive = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: AssignmentCell.cellHeight + 20)

        let heightAnchor = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 290)
        heightAnchor.priority = UILayoutPriority(999)
        heightAnchor.isActive = true
    }

    func configure(_ item: [Assignment], at indexPath: IndexPath) {
        guard item.count > 0 else {
            return
        }
        let siteId = item[0].siteId
        let title = SakaiService.shared.siteTitleMap[siteId]
        titleLabel.text = title
        if let code = item[0].subjectCode {
            titleLabel.iconText = AppIcons.codeToIcon[code]
        } else {
            titleLabel.iconText = nil
        }

        manager.loadItems(payload: item)
        manager.reloadData()
    }
}
