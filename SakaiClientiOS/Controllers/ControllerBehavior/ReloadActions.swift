//
//  ReloadActions.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 10/7/18.
//

import Foundation

/// When user's source of truth data has changed, i.e.
/// mappings from siteId to Term, all controllers in the app
/// need to be refreshed with new data. This situation also
/// occurs when a new user logs in or when the site list in
/// HomeController is reloaded. Different notifications
/// are sent using NotificationCenter to alert the controllers
/// to refresh themselves. Each notification action is enumerated
///
///
/// - reload: reload general data controllers. Ex. Gradebook, Announcement
/// - reloadHome: refresh the Site list (HomeController) and therefore
///               update the source of truth mappings as well
enum ReloadActions: String {
    case reload = "reload" 
    case reloadHome = "reloadHome"
}
