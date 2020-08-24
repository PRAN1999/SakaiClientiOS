//
//  CheckBoxCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/23/18.
//

import UIKit
import ReusableSource
import M13Checkbox

class CheckBoxCell: UITableViewCell, ReusableCell {

    let checkBox: M13Checkbox = {
        let checkBox: M13Checkbox = UIView.defaultAutoLayoutView()
        checkBox.boxType = .square
        checkBox.stateChangeAnimation = .fill
        checkBox.tintColor = Palette.main.highlightColor
        checkBox.isEnabled = false
        return checkBox
    }()

    let label: UILabel = {
        let label: UILabel = UIView.defaultAutoLayoutView()
        label.font = UIFont.systemFont(ofSize: 21.0)
        label.backgroundColor = Palette.main.primaryBackgroundColor
        label.textColor = Palette.main.secondaryTextColor
        return label
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

        contentView.addSubview(label)
        contentView.addSubview(checkBox)
    }

    private func setConstraints() {
        let margins = contentView.layoutMarginsGuide

        label.constrainToMargins(of: contentView, onSides: [.left, .top, .bottom])
        label.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor).isActive = true

        checkBox.constrainToMargin(of: contentView, onSide: .right)
        checkBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 5.0).isActive = true
        checkBox.heightAnchor.constraint(equalTo: margins.heightAnchor).isActive = true
        checkBox.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.15).isActive = true
    }

}
