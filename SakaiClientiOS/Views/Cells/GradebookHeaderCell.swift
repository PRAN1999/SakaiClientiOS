//
//  FloatingHeaderCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/3/18.
//

import UIKit
import ReusableSource

/// The "floating" header used in the gradebook view
class GradebookHeaderCell: UITableViewCell, ReusableCell {

    let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: nil, action: nil)

    let titleLabel: UILabel = {
        let titleLabel: UILabel = UIView.defaultAutoLayoutView()
        titleLabel.textColor = Palette.main.secondaryTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        return titleLabel
    }()

    let iconLabel: UILabel = {
        let iconLabel: UILabel = UIView.defaultAutoLayoutView()
        iconLabel.font = UIFont(name: AppIcons.siteFont, size: 30.0)
        iconLabel.textColor = Palette.main.primaryTextColor
        return iconLabel
    }()

    private lazy var iconVisibleConstraint: NSLayoutConstraint = {
        let margins = contentView.layoutMarginsGuide
        return iconLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.10)
    }()
    private lazy var iconHiddenConstraint: NSLayoutConstraint = {
        let margins = contentView.layoutMarginsGuide
        return iconLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0)
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
        selectedBackgroundView?.addBorder(toSide: .left, withColor: Palette.main.highlightColor, andThickness: 5.0)
        backgroundView = defaultBackgroundView()
        backgroundView?.addBorder(toSide: .left, withColor: Palette.main.highlightColor, andThickness: 5.0)

        contentView.addSubview(titleLabel)
        contentView.addSubview(iconLabel)
        addGestureRecognizer(tapRecognizer)
    }

    private func setConstraints() {
        let margins = contentView.layoutMarginsGuide

        iconLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        iconLabel.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        iconLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        iconLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true

        iconVisibleConstraint.isActive = true

        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 20.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1.0).isActive = true
    }

    func setFrameAndMakeVisible(frame: CGRect) {
        self.frame = frame
        self.isHidden = false
    }

    func configure(title: String?, subjectCode: Int?) {
        iconVisibleConstraint.isActive = false
        iconHiddenConstraint.isActive = false
        titleLabel.text = title
        if let code = subjectCode, let icon = AppIcons.codeToIcon[code] {
            iconLabel.text = icon
            iconVisibleConstraint.isActive = true
        } else {
            iconLabel.text = nil
            iconHiddenConstraint.isActive = true
        }
    }
}
