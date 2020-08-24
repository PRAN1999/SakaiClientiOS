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
    let highlightColor: UIColor // Main accent color for app
    let tableViewSeparatorColor: UIColor
    let scrollViewIndicatorStyle: UIScrollView.IndicatorStyle

    let primaryTextColor: UIColor // Used for icons, Term Headers...
    let secondaryTextColor: UIColor // Used for everything else

    let primaryBackgroundColor: UIColor
    let secondaryBackgroundColor: UIColor
    let tertiaryBackgroundColor: UIColor

    let activityIndicatorColor: UIColor
    let borderColor: UIColor
    let blurStyle: UIBlurEffect.Style

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
        scrollViewIndicatorStyle: UIScrollView.IndicatorStyle,
        primaryTextColor: UIColor,
        secondaryTextColor: UIColor,
        primaryBackgroundColor: UIColor,
        secondaryBackgroundColor: UIColor,
        tertiaryBackgroundColor: UIColor,
        activityIndicatorColor: UIColor,
        borderColor: UIColor,
        blurStyle: UIBlurEffect.Style,
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
