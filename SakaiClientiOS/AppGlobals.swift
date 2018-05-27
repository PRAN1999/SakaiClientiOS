//
//  AppGlobals.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/16/18.
//

import Foundation

final class AppGlobals {
    static var siteTermMap:[String: Term] = [:]
    static var siteTitleMap:[String:String] = [:]
    
    static var TO_RELOAD:Bool = true
    
    static let LOGIN_URL:String = "https://cas.rutgers.edu/login?service=https%3A%2F%2Fsakai.rutgers.edu%2Fsakai-login-tool%2Fcontainer"
    static let COOKIE_URL_1:String = "https://sakai.rutgers.edu/sakai-login-tool/container"
    static let COOKIE_URL_2:String = "https://sakai.rutgers.edu/portal"
    
    static let BASE_URL:String = "https://sakai.rutgers.edu/direct/"
    
    static let SITES_URL:String = BASE_URL + "site.json"
    static let SESSION_URL:String = BASE_URL + "session/current.json"
    static let USER_URL:String = BASE_URL + "user/current.json"
    static let SITE_GRADEBOOK_URL = BASE_URL + "gradebook/site/*.json"
    static let GRADEBOOK_URL = BASE_URL + "gradebook/my.json"
    
    static func flushGlobals() {
        self.siteTermMap = [:]
        self.siteTitleMap = [:]
    }
}
