//
//  AppGlobals.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/16/18.
//

import Foundation
import WebKit

final class AppGlobals {
    
    static let LOGIN_URL:String = "https://cas.rutgers.edu/login?service=https%3A%2F%2Fsakai.rutgers.edu%2Fsakai-login-tool%2Fcontainer"
    static let COOKIE_URL_1:String = "https://sakai.rutgers.edu/sakai-login-tool/container"
    static let COOKIE_URL_2:String = "https://sakai.rutgers.edu/portal"
    
    static let BASE_URL:String = "https://sakai.rutgers.edu/direct/"
    
    static let SITES_URL:String = BASE_URL + "site.json"
    static let SESSION_URL:String = BASE_URL + "session/current.json"
    static let USER_URL:String = BASE_URL + "user/current.json"
    static let SITE_GRADEBOOK_URL = BASE_URL + "gradebook/site/*.json"
    static let GRADEBOOK_URL = BASE_URL + "gradebook/my.json"
    static let ASSIGNMENT_URL = BASE_URL + "assignment/my.json"
    static let SITE_ASSIGNMENT_URL = BASE_URL + "assignment/site/*.json"
    static let ANNOUNCEMENT_URL = BASE_URL + "announcement/user.json?n=*&d=10000"
    static let SITE_ANNOUNCEMENTS_URL = BASE_URL + "announcement/site/*.json?n=#&d=10000"
    
    static let SAKAI_RED = UIColor(red: 199 / 255.0, green: 37 / 255.0, blue: 78 / 255.0, alpha: 1.0)
    
}
