//
//  AppGlobals.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/16/18.
//

import Foundation
import WebKit

final class AppGlobals {
    static let loginUrl         = "http://cas.rutgers.edu/login?service=https%3A%2F%2Fsakai.rutgers.edu%2Fsakai-login-tool%2Fcontainer"
    static let emailLoginUrl    = "https://sakai.rutgers.edu/portal/xlogin"
    static let cookieUrl       = "https://sakai.rutgers.edu/portal"
}

extension UIColor {
    static let darkThemeLinkColor = UIColor(red: 70.0 / 256.0, green: 188.0 / 256.0, blue: 222.0 / 256.0, alpha: 1.0)

    static let sakaiRed = UIColor(red: 199 / 255.0, green: 37 / 255.0, blue: 78 / 255.0, alpha: 1.0)
    static let defaultTint = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
}
