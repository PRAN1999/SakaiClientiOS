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
    
    var shouldSetConstraints = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        if shouldSetConstraints {
            setConstraints()
            shouldSetConstraints = false
        }
        super.updateConstraints()
    }

    func setup() {
        titleLabel = UILabel()
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 11.0, weight: UIFont.Weight.light)

        self.backgroundColor = AppGlobals.sakaiRed
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        setNeedsUpdateConstraints()
    }

    func addViews() {
        self.addSubview(titleLabel)
    }

    func setConstraints() {
        let margins = self.layoutMarginsGuide

        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
}
