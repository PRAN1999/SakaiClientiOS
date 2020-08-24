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

    let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: nil,
                                                                       action: nil)

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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
        backgroundView = defaultBackgroundView()
        backgroundView?.addBorder(toSide: .left,
                                  withColor: Palette.main.highlightColor,
                                  andThickness: 5.0)

        contentView.addSubview(titleLabel)
        contentView.addSubview(iconLabel)
        addGestureRecognizer(tapRecognizer)
    }

    private func setConstraints() {
        iconLabel.constrainToMargins(of: contentView,
                                     onSides: [.top, .bottom, .left])
        iconLabel.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor,
                                            constant: -5.0).isActive = true

        iconVisibleConstraint.isActive = true
        titleLabel.constrainToMargins(of: contentView,
                                      onSides: [.top, .bottom, .right])
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
