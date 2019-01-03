//
//  Theme.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/2/19.
//

import Foundation
import UIKit

enum Theme {

    static var selected: Theme = .dark

    private static let darkPalette = Palette(navigationTintColor: UIColor.sakaiTint,
                                             navigationTitleColor: UIColor.white,
                                             navigationBackgroundColor: UIColor(white: 0.08, alpha: 1.0),
                                             toolBarColor: UIColor.white,
                                             tabBarTintColor: UIColor.sakaiTint,
                                             tabBarUnselectedTintColor: UIColor.white,
                                             tabBarBackgroundColor: UIColor.black.color(withTransparency: 0.7),
                                             barStyle: .black,
                                             highlightColor: UIColor.sakaiTint,
                                             tableViewSeparatorColor: UIColor.lightText,
                                             scrollViewIndicatorStyle: .white,
                                             primaryTextColor: UIColor.defaultTint,
                                             secondaryTextColor: UIColor.lightText,
                                             primaryBackgroundColor: UIColor.midnightGray,
                                             secondaryBackgroundColor: UIColor.darkGray,
                                             tertiaryBackgroundColor: UIColor.gray,
                                             activityIndicatorColor: UIColor.white,
                                             borderColor: UIColor.lightText,
                                             blurStyle: .dark,
                                             linkColor: UIColor.darkThemeLinkColor,
                                             pageIndicatorTintColor: UIColor.darkGray)

    case dark
    //case light

    var palette: Palette {
        switch self {
        case .dark:
            return Theme.darkPalette
        }
    }
}
