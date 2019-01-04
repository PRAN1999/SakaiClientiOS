//
//  DetailLabel.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/20/18.
//

import UIKit

/// A UILabel to represent any key-value pair
class DetailLabel: UILabel {

    let iconLabel: UILabel = {
        let iconLabel: UILabel = UIView.defaultAutoLayoutView()
        iconLabel.font = UIFont(name: AppIcons.generalIconFont, size: 20.0)
        iconLabel.textColor = Palette.main.tertiaryBackgroundColor
        return iconLabel
    }()

    let titleLabel: UILabel = {
        let titleLabel: UILabel = UIView.defaultAutoLayoutView()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = Palette.main.primaryTextColor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        return titleLabel
    }()

    let detailLabel: UILabel = {
        let detailLabel: UILabel = UIView.defaultAutoLayoutView()
        detailLabel.textAlignment = .right
        detailLabel.textColor = Palette.main.secondaryTextColor
        return detailLabel
    }()

    private lazy var iconVisibleConstraint: NSLayoutConstraint = {
        let margins = layoutMarginsGuide
        return iconLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.10)
    }()
    private lazy var iconHiddenConstraint: NSLayoutConstraint = {
        let margins = layoutMarginsGuide
        return iconLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }

    var iconText: String? {
        get {
            return iconLabel.text
        } set {
            iconHiddenConstraint.isActive = false
            iconVisibleConstraint.isActive = false
            iconLabel.text = newValue
            if newValue == nil {
                iconHiddenConstraint.isActive = true
            } else {
                iconVisibleConstraint.isActive = true
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(iconLabel)
        addSubview(titleLabel)
        addSubview(detailLabel)
    }

    private func setConstraints() {
        let margins = self.layoutMarginsGuide

        iconLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        iconLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: detailLabel.leadingAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5)

        detailLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }

    /// Set the key-value text of the view
    ///
    /// - Parameters:
    ///   - key: The key string in the key-value pair
    ///   - val: A value to be associated with the key
    func setKeyVal(key: String, val: Any?) {
        titleLabel.text = key
        guard let value = val else {
            return
        }
        detailLabel.text = "\(value)"
    }
}
