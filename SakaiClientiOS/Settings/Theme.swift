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

    private static let darkPalette = Palette(navigationTintColor: UIColor.sakaiRed,
                                             navigationTitleColor: UIColor.white,
                                             tabBarTintColor: UIColor.red,
                                             tabBarUnselectedTintColor: UIColor.white,
                                             tabBarBackgroundColor: UIColor.black,
                                             barStyle: .black,
                                             highlightColor: UIColor.sakaiRed,
                                             primaryTextColor: UIColor.white,
                                             secondaryTextColor: UIColor.lightText,
                                             primaryBackgroundColor: UIColor.darkGray,
                                             secondaryBackgroundColor: UIColor.lightGray,
                                             tertiaryBackgroundColor: UIColor.gray,
                                             activityIndicatorColor: UIColor.white,
                                             borderColor: UIColor.lightText,
                                             blurStyle: .dark,
                                             linkColor: UIColor.darkThemeLinkColor)

    case dark
    //case light

    var palette: Palette {
        switch self {
        case .dark:
            return Theme.darkPalette
        }
    }
}
