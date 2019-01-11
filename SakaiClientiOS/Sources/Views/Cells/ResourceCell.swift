//
//  ResourceCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/28/18.
//

import UIKit
import ReusableSource

/// A cell to display a Resource collection or element
class ResourceCell: UITableViewCell, ReusableCell {

    static let level1Color = UIColor(red: 199.0 / 256.0,
                                     green: 26.0 / 255.0,
                                     blue: 36.0 / 255.0,
                                     alpha: 1.0)
    static let level2Color = UIColor(red: 199.0 / 256.0,
                                     green: 66.0 / 255.0,
                                     blue: 36.0 / 255.0,
                                     alpha: 1.0)
    static let level3Color = UIColor(red: 199.0 / 256.0,
                                     green: 104.0 / 255.0,
                                     blue: 36.0 / 255.0,
                                     alpha: 1.0)
    static let level4Color = UIColor(red: 199.0 / 256.0,
                                     green: 142.0 / 255.0,
                                     blue: 36.0 / 255.0,
                                     alpha: 1.0)

    typealias T = ResourceItem

    let titleLabel: InsetUILabel = {
        let titleLabel: InsetUILabel = UIView.defaultAutoLayoutView()
        titleLabel.textColor = Palette.main.secondaryTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.light)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.layer.cornerRadius = 0
        titleLabel.layer.masksToBounds = false
        return titleLabel
    }()

    let leftBorder: UIView = UIView.defaultAutoLayoutView()

    let sizeLabel: UILabel = {
        let sizeLabel: UILabel = UIView.defaultAutoLayoutView()
        sizeLabel.backgroundColor = Palette.main.secondaryBackgroundColor
        sizeLabel.textAlignment = .center
        sizeLabel.textColor = Palette.main.primaryTextColor
        sizeLabel.layer.masksToBounds = true
        return sizeLabel
    }()

    let spaceView: UIView = UIView.defaultAutoLayoutView()

    var needsSizeLabel = false

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
        contentView.addSubview(leftBorder)
        contentView.addSubview(sizeLabel)
        contentView.addSubview(spaceView)
    }

    private func setConstraints() {
        leftBorder.constrainToMargins(of: contentView, onSides: [.left, .top, .bottom])
        leftBorder.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        leftBorder.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.015).isActive = true

        titleLabel.constrainToMargins(of: contentView, onSides: [.top, .bottom])
        titleLabel.trailingAnchor.constraint(equalTo: sizeLabel.leadingAnchor).isActive = true

        sizeLabel.constrainToMargins(of: contentView, onSides: [.top, .bottom])
        sizeLabel.trailingAnchor.constraint(equalTo: spaceView.leadingAnchor).isActive = true
        sizeLabel.widthAnchor.constraint(equalTo: sizeLabel.heightAnchor).isActive = true

        spaceView.constrainToMargins(of: contentView, onSides: [.right, .top, .bottom])
    }

    func configure(_ item: ResourceItem, at level: Int, isExpanded: Bool) {
        titleLabel.titleLabel.text = item.title
        leftBorder.backgroundColor = getColor(for: level)
        let left = CGFloat(level == 0 ? 0 : level * 20 + 10)
        contentView.layoutMargins.left = left
        switch item.type {
        case .collection:
            selectionStyle = .none
            accessoryType = .none
            sizeLabel.text = String(item.numChildren)
            sizeLabel.isHidden = false
            if isExpanded {
                sizeLabel.backgroundColor = getColor(for: level)
            } else {
                sizeLabel.backgroundColor = Palette.main.secondaryBackgroundColor
            }
            break
        case .resource:
            selectionStyle = .default
            accessoryType = .disclosureIndicator
            sizeLabel.isHidden = true
            break
        }
        layoutSubviews()
    }

    private func getColor(for level: Int) -> UIColor {
        let mod = level % 4
        switch mod {
        case 0:
            return ResourceCell.level1Color
        case 1:
            return ResourceCell.level2Color
        case 2:
            return ResourceCell.level3Color
        case 3:
            return ResourceCell.level4Color
        default:
            return UIColor.black
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutSubviews()
        sizeLabel.layer.cornerRadius = sizeLabel.bounds.size.height / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        sizeLabel.backgroundColor = Palette.main.secondaryBackgroundColor
    }
}
