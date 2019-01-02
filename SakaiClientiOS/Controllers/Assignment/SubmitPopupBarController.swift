//
//  SubmitPopupBar.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/31/18.
//

import Foundation
import LNPopupController

class SubmitPopupBarController: LNPopupCustomBarViewController {

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
        UIView.constrainChildToEdges(child: titleLabel, parent: blurEffectView.contentView)
        return blurEffectView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        UIView.constrainChildToEdges(child: blurEffectView, parent: view)

        preferredContentSize.height = 44
    }
}
