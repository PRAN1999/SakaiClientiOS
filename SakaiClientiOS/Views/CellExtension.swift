//
//  UITableViewCellExtension.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/21/18.
//

import Foundation
import UIKit

extension UITableViewCell {
    func darkSelectedView() -> UIView {
        let view = UIView()
        view.backgroundColor = Palette.main.secondaryBackgroundColor.color(withTransparency: 0.5)
        return view
    }

    func defaultBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = Palette.main.primaryBackgroundColor
        return view
    }
}

extension UICollectionViewCell {
    func darkSelectedView() -> UIView {
        let view = UIView()
        view.backgroundColor = Palette.main.secondaryBackgroundColor.color(withTransparency: 0.5)
        return view
    }

    func defaultBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = Palette.main.primaryBackgroundColor
        return view
    }
}
