//
//  FloatingHeaderCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/3/18.
//

import UIKit
import ReusableSource

/// The "floating" header used in the gradebook view
class FloatingHeaderCell: UITableViewCell, ReusableCell {

    let titleLabel: UILabel = {
        let titleLabel: UILabel = UIView.defaultAutoLayoutView()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        return titleLabel
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = UIColor.black//AppGlobals.sakaiRed
        isHidden = true

        contentView.addSubview(titleLabel)
    }

    func setConstraints() {
        let margins = self.contentView.layoutMarginsGuide

        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 20.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1.0).isActive = true
    }

    func setTitle(title: String?) {
        titleLabel.text = title
    }

    func setFrameAndMakeVisible(frame: CGRect) {
        self.frame = frame
        self.isHidden = false
    }
}
