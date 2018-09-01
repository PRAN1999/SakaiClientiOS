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

    var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        addViews()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.backgroundColor = AppGlobals.sakaiRed

        titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)

        self.isHidden = true
    }

    func addViews() {
        self.contentView.addSubview(titleLabel)
    }

    func setConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 20.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1.0).isActive = true
    }

    /// Set the text of the titleLabel
    ///
    /// - Parameter title: The title text to set
    func setTitle(title: String?) {
        titleLabel.text = title
    }

    /// Make the floating header visible in the specified frame
    ///
    /// - Parameter frame: The frame in which the cell should be visible
    func setFrameAndMakeVisible(frame: CGRect) {
        self.frame = frame
        self.isHidden = false
    }
}
