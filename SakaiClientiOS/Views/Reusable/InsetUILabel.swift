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

        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
}
