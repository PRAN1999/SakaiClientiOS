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

    private static let darkPalette = Palette(navigationTintColor: UIColor.sakaiTint,//UIColor(red: 186/255, green: 22/255, blue: 46/255, alpha: 1.0)
                                             navigationTitleColor: UIColor.white,//UIColor(white: 1.0, alpha: 1.0)
                                             navigationBackgroundColor: UIColor(white: 0.08, alpha: 1.0),
                                             toolBarColor: UIColor.white,//UIColor(white: 1.0, alpha: 1.0)
                                             tabBarTintColor: UIColor.sakaiTint,//UIColor(red: 186/255, green: 22/255, blue: 46/255, alpha: 1.0)
                                             tabBarUnselectedTintColor: UIColor.white,//UIColor(white: 1.0, alpha: 1.0)
                                             tabBarBackgroundColor: UIColor.black.color(withTransparency: 0.7),//UIColor(white: 0.0, alpha: 0.7)
                                             barStyle: .black,
                                             highlightColor: UIColor.sakaiTint,//UIColor(red: 186/255, green: 22/255, blue: 46/255, alpha: 1.0)
                                             tableViewSeparatorColor: UIColor.lightText,//UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
                                             scrollViewIndicatorStyle: .white,
                                             primaryTextColor: UIColor.defaultTint,//Used for icons and Term Headers - UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
                                             secondaryTextColor: UIColor.lightText,//Used for basically everything else - UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
                                             primaryBackgroundColor: UIColor.midnightGray,//UIColor(white: 0.15, alpha: 1.0)
                                             secondaryBackgroundColor: UIColor.darkGray,//UIColor(white: 1/3, alpha: 1.0)
                                             tertiaryBackgroundColor: UIColor.gray,//UIColor(white: 1/2, alpha: 1.0)
                                             activityIndicatorColor: UIColor.white,////UIColor(white: 1.0, alpha: 1.0)
                                             borderColor: UIColor.lightText,//UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
                                             blurStyle: .dark,
                                             linkColor: UIColor.darkThemeLinkColor,//UIColor(red: 70.0 / 256.0, green: 188.0 / 256.0, blue: 222.0 / 256.0, alpha: 1.0)
                                             pageIndicatorTintColor: UIColor.darkGray)//UIColor(white: 1/3, alpha: 1.0)

    case dark
    //case light

    var palette: Palette {
        switch self {
        case .dark:
            return Theme.darkPalette
        }
    }
}
