//
//  TermHeader.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/28/18.
//

import Foundation
import UIKit
import ReusableSource

/// The default section header to be used across the app to separate by Term in a HideableTableSource
class TermHeader: UITableViewHeaderFooterView, UIGestureRecognizerDelegate, ReusableCell {

    let titleLabel: UILabel = {
        let titleLabel: UILabel = UIView.defaultAutoLayoutView()
        titleLabel.font = UIFont.systemFont(ofSize: 25.0, weight: .medium)
        titleLabel.textColor = Palette.main.primaryTextColor
        return titleLabel
    }()

    let imageLabel: UIImageView = {
        let imageLabel: UIImageView = UIView.defaultAutoLayoutView()
        imageLabel.tintColor = Palette.main.primaryTextColor
        return imageLabel
    }()

    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator: UIActivityIndicatorView = UIView.defaultAutoLayoutView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = Palette.main.activityIndicatorColor
        return activityIndicator
    }()

    var backgroundHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = Palette.main.secondaryBackgroundColor
        return view
    }()

    let tapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: nil, action: nil)
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        return tapRecognizer
    }()

    private var centerConstraint: NSLayoutConstraint!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundView = backgroundHeaderView
        tapRecognizer.delegate = self

        addSubview(titleLabel)
        addSubview(imageLabel)
        addSubview(activityIndicator)
        addBorder(toSide: .bottom, withColor: Palette.main.borderColor, andThickness: 0.5)
        backgroundView = backgroundHeaderView
        addGestureRecognizer(tapRecognizer)
    }

    private func setConstraints() {
        let margins = layoutMarginsGuide

        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: activityIndicator.leadingAnchor, constant: -20.0).isActive = true

        activityIndicator.topAnchor.constraint(lessThanOrEqualTo: margins.topAnchor,
                                               constant: 5.0).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        let constraint = NSLayoutConstraint(item: activityIndicator,
                                            attribute: .trailing,
                                            relatedBy: .lessThanOrEqual,
                                            toItem: imageLabel,
                                            attribute: .leading,
                                            multiplier: 1.0,
                                            constant: -20)
        constraint.priority = UILayoutPriority(999)
        addConstraint(constraint)

        imageLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -5.0).isActive = true
        centerConstraint = imageLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        centerConstraint.isActive = true
    }

    /// Change the image of the header on tap to indicate a collapsed or expanded section
    ///
    /// - Parameter isHidden: A variable to determine which image should be shown based on whether the section is hidden or open
    func setImage(isHidden: Bool) {
        imageLabel.layer.removeAllAnimations()
        if isHidden {
            imageLabel.image = UIImage(named: "show_content")?.withRenderingMode(.alwaysTemplate)
            centerConstraint.constant = -5
        } else {
            imageLabel.image = UIImage(named: "hide_content")?.withRenderingMode(.alwaysTemplate)
            centerConstraint.constant = 0
        }
    }
}
