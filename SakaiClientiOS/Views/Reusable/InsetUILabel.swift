//
//  InsetUILabel.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/12/18.
//

import UIKit

/// A UILabel inset with padding around the edges
class InsetUILabel: UILabel, UIGestureRecognizerDelegate {
    
    /// The titleLabel containing the inset content of the view
    let titleLabel: UILabel = {
        let titleLabel: UILabel = UIView.defaultAutoLayoutView()
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 11.0, weight: UIFont.Weight.light)
        return titleLabel
    }()

    private var leadingConstraint: NSLayoutConstraint!

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = AppGlobals.sakaiRed
        layer.cornerRadius = 3
        layer.masksToBounds = true

        addSubview(titleLabel)
    }

    private func setConstraints() {
        let margins = layoutMarginsGuide

        leadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        leadingConstraint.isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }

    func setLeftMargin(to val: CGFloat) {
        let margins = layoutMarginsGuide

        leadingConstraint.isActive = false
        removeConstraint(leadingConstraint)
        leadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: val)
        leadingConstraint.isActive = true
    }
}
