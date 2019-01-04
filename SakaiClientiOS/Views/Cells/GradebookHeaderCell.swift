//
//  FloatingHeaderCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/3/18.
//

import UIKit
import ReusableSource

/// The "floating" header used in the gradebook view
class GradebookHeaderCell: UITableViewCell, ReusableCell {

    let titleLabel: InsetUILabel = {
        let titleLabel: InsetUILabel = UIView.defaultAutoLayoutView()
        titleLabel.textColor = Palette.main.secondaryTextColor
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        titleLabel.layer.cornerRadius = 0
        titleLabel.layer.masksToBounds = false
        return titleLabel
    }()

    let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: nil, action: nil)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Palette.main.primaryBackgroundColor
        selectedBackgroundView = selectedView()
        selectedBackgroundView?.addBorder(toSide: .left,
                                          withColor: Palette.main.highlightColor,
                                          andThickness: 5.0)
        backgroundView = defaultBackgroundView()
        backgroundView?.addBorder(toSide: .left, withColor: Palette.main.highlightColor, andThickness: 5.0)

        contentView.addSubview(titleLabel)
        addGestureRecognizer(tapRecognizer)
    }

    private func setConstraints() {
        let margins = contentView.layoutMarginsGuide

        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    func setFrameAndMakeVisible(frame: CGRect) {
        self.frame = frame
        self.isHidden = false
    }
}
