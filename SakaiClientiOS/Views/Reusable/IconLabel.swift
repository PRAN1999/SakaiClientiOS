//
//  InsetUILabel.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/12/18.
//

import UIKit

/// A UILabel inset with padding around the edges
class IconLabel: UILabel, UIGestureRecognizerDelegate {
    
    /// The titleLabel containing the inset content of the view
    let titleLabel: UILabel = {
        let titleLabel: UILabel = UIView.defaultAutoLayoutView()
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 11.0, weight: UIFont.Weight.light)
        return titleLabel
    }()

    let iconLabel: UILabel = {
        let iconLabel: UILabel = UIView.defaultAutoLayoutView()
        iconLabel.font = UIFont(name: AppIcons.siteFont, size: 30.0)
        iconLabel.textColor = Palette.main.primaryTextColor
        iconLabel.textAlignment = .right
        return iconLabel
    }()

    private lazy var leadingConstraint: NSLayoutConstraint = {
        let margins = layoutMarginsGuide
        return iconLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
    }()

    lazy var iconVisibleConstraint: NSLayoutConstraint = {
        let margins = layoutMarginsGuide
        return iconLabel.widthAnchor.constraint(equalToConstant: 30)
    }()
    lazy var iconHiddenConstraint: NSLayoutConstraint = {
        let margins = layoutMarginsGuide
        return iconLabel.widthAnchor.constraint(equalTo: margins.widthAnchor,
                                                multiplier: 0)
    }()
    lazy var iconTitleConstraint: NSLayoutConstraint = {
        return iconLabel.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor,
                                                   constant: -5.0)
    }()

    override var text: String? {
        get {
            return titleLabel.text
        } set {
            titleLabel.text = newValue
        }
    }

    override var numberOfLines: Int {
        get {
            return titleLabel.numberOfLines
        } set {
            titleLabel.numberOfLines = newValue
        }
    }

    override var lineBreakMode: NSLineBreakMode {
        get {
            return titleLabel.lineBreakMode
        } set {
            titleLabel.lineBreakMode = newValue
        }
    }

    override var textAlignment: NSTextAlignment {
        get {
            return titleLabel.textAlignment
        } set {
            titleLabel.textAlignment = newValue
        }
    }

    override var font: UIFont! {
        didSet {
            titleLabel.font = font
        }
    }

    override var textColor: UIColor! {
        didSet {
            titleLabel.textColor = textColor
        }
    }

    var iconText: String? {
        get {
            return iconLabel.text
        } set {
            iconVisibleConstraint.isActive = false
            iconHiddenConstraint.isActive = false
            iconLabel.text = newValue
            if newValue == nil {
                iconHiddenConstraint.isActive = true
            } else {
                iconVisibleConstraint.isActive = true
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Palette.main.primaryBackgroundColor
        layer.cornerRadius = 3
        layer.masksToBounds = true

        addSubview(titleLabel)
        addSubview(iconLabel)
    }

    private func setConstraints() {
        leadingConstraint.isActive = true
        iconLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        iconTitleConstraint.isActive = true

        titleLabel.constrainToMargins(of: self, onSides: [.top, .bottom, .right])
    }

    func setLeftMargin(to val: CGFloat) {
        leadingConstraint.constant = val
    }
}
