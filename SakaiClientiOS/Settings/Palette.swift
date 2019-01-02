//
//  Palette.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/2/19.
//

import Foundation
import UIKit

struct Palette {
    let navigationTintColor: UIColor
    let navigationTitleColor: UIColor

    let tabBarTintColor: UIColor
    let tabBarUnselectedTintColor: UIColor
    let tabBarBackgroundColor: UIColor

    let barStyle: UIBarStyle
    let highlightColor: UIColor

    let primaryTextColor: UIColor
    let secondaryTextColor: UIColor

    let primaryBackgroundColor: UIColor
    let secondaryBackgroundColor: UIColor
    let tertiaryBackgroundColor: UIColor

    let activityIndicatorColor: UIColor
    let borderColor: UIColor
    let blurStyle: UIBlurEffectStyle

    let linkColor: UIColor
}

extension Palette {
    static var main: Palette {
        return Theme.selected.palette
    }
}
