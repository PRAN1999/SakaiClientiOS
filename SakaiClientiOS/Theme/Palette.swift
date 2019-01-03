//
//  Palette.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/2/19.
//

import Foundation
import UIKit

class Palette {
    let navigationTintColor: UIColor
    let navigationTitleColor: UIColor
    let navigationBackgroundColor: UIColor
    let toolBarColor: UIColor

    let tabBarTintColor: UIColor
    let tabBarUnselectedTintColor: UIColor
    let tabBarBackgroundColor: UIColor

    let barStyle: UIBarStyle
    let highlightColor: UIColor
    let tableViewSeparatorColor: UIColor
    let scrollViewIndicatorStyle: UIScrollViewIndicatorStyle

    let primaryTextColor: UIColor
    let secondaryTextColor: UIColor

    let primaryBackgroundColor: UIColor
    let secondaryBackgroundColor: UIColor
    let tertiaryBackgroundColor: UIColor

    let activityIndicatorColor: UIColor
    let borderColor: UIColor
    let blurStyle: UIBlurEffectStyle

    let linkColor: UIColor
    let pageIndicatorTintColor: UIColor

    init(
        navigationTintColor: UIColor,
        navigationTitleColor: UIColor,
        navigationBackgroundColor: UIColor,
        toolBarColor: UIColor,
        tabBarTintColor: UIColor,
        tabBarUnselectedTintColor: UIColor,
        tabBarBackgroundColor: UIColor,
        barStyle: UIBarStyle,
        highlightColor: UIColor,
        tableViewSeparatorColor: UIColor,
        scrollViewIndicatorStyle: UIScrollViewIndicatorStyle,
        primaryTextColor: UIColor,
        secondaryTextColor: UIColor,
        primaryBackgroundColor: UIColor,
        secondaryBackgroundColor: UIColor,
        tertiaryBackgroundColor: UIColor,
        activityIndicatorColor: UIColor,
        borderColor: UIColor,
        blurStyle: UIBlurEffectStyle,
        linkColor: UIColor,
        pageIndicatorTintColor: UIColor
        ) {
        self.navigationTintColor = navigationTintColor
        self.navigationTitleColor = navigationTitleColor
        self.navigationBackgroundColor = navigationBackgroundColor
        self.toolBarColor = toolBarColor
        self.tabBarTintColor = tabBarTintColor
        self.tabBarUnselectedTintColor = tabBarUnselectedTintColor
        self.tabBarBackgroundColor = tabBarBackgroundColor
        self.barStyle = barStyle
        self.highlightColor = highlightColor
        self.tableViewSeparatorColor = tableViewSeparatorColor
        self.scrollViewIndicatorStyle = scrollViewIndicatorStyle
        self.primaryTextColor = primaryTextColor
        self.secondaryTextColor = secondaryTextColor
        self.primaryBackgroundColor = primaryBackgroundColor
        self.secondaryBackgroundColor = secondaryBackgroundColor
        self.tertiaryBackgroundColor = tertiaryBackgroundColor
        self.activityIndicatorColor = activityIndicatorColor
        self.borderColor = borderColor
        self.blurStyle = blurStyle
        self.linkColor = linkColor
        self.pageIndicatorTintColor = pageIndicatorTintColor
    }
}

extension Palette {
    static var main: Palette {
        return Theme.selected.palette
    }
}
