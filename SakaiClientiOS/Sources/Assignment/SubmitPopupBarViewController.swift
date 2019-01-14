//
//  SubmitPopupBar.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/31/18.
//

import Foundation
import LNPopupController

/// A customized LNPopupBar for submitting Assignments
class SubmitPopupBarViewController: LNPopupCustomBarViewController {

    let iconLabel: UILabel = {
        let iconLabel: UILabel = UIView.defaultAutoLayoutView()
        iconLabel.font = UIFont(name: AppIcons.generalIconFont, size: 25.0)
        iconLabel.textColor = Palette.main.primaryTextColor
        iconLabel.text = AppIcons.slideUpIcon
        iconLabel.textAlignment = .right
        return iconLabel
    }()

    let titleLabel: UILabel = {
        let label: UILabel = UIView.defaultAutoLayoutView()
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        label.textAlignment = .center
        label.textColor = Palette.main.primaryTextColor
        return label
    }()

    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: Palette.main.blurStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        let contentView = blurEffectView.contentView

        contentView.addSubview(iconLabel)
        contentView.addSubview(titleLabel)

        let margins = contentView

        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            iconLabel.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -5.0),
            titleLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor)
        ])
        return blurEffectView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Palette.main.primaryBackgroundColor
        view.addBorder(toSide: .top, withColor: Palette.main.highlightColor, andThickness: 2)
        view.addBorder(toSide: .left, withColor: Palette.main.highlightColor, andThickness: 2)
        view.addBorder(toSide: .right, withColor: Palette.main.highlightColor, andThickness: 2)
        view.addBorder(toSide: .bottom, withColor: Palette.main.highlightColor, andThickness: 1)
        view.addSubview(blurEffectView)
        blurEffectView.constrainToEdges(of: view)

        preferredContentSize.height = 44
    }
}
