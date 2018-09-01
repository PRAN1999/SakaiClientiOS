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
    var titleLabel: UILabel!
    var tapRecognizer: UITapGestureRecognizer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addViews()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        titleLabel = UILabel()
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 11.0, weight: UIFont.Weight.light)

        self.backgroundColor = AppGlobals.SAKAI_RED
        // Round the edges of outer view
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
    }

    func addViews() {
        self.addSubview(titleLabel)
    }

    func setConstraints() {
        let margins = self.layoutMarginsGuide
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        // Constrain titleLabel to margins to ensure padding between content and view border
        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
}
