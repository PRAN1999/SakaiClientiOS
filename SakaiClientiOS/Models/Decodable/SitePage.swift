//
//  SitePage.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/11/18.
//
import Foundation

/// A model for the individual subpages belonging to each Site
struct SitePage {
    private static let announcementString: String = "Announcements"
    private static let assignmentsString: String  = "Assignments"
    private static let gradebookString: String    = "Gradebook"
    private static let resourcesString: String    = "Resources"
    private static let chatRoomString: String     = "Chat Room"
    private static let defaultString: String      = "None"

    /// A map to provide native interfaces for common site pages shared by most classes
    private static let mapPages: [String: SitePageController.Type] = [
        assignmentsString:  SiteAssignmentController.self,
        gradebookString:    SiteGradebookController.self,
        chatRoomString:     ChatRoomController.self,
        defaultString:      DefaultController.self,
        resourcesString:    ResourcePageController.self,
        announcementString: SiteAnnouncementController.self
    ]

    let id: String
    let title: String
    let siteId: String
    let siteType: SitePageController.Type
    let url: String
}

extension SitePage: Decodable {
    init(from decoder: Decoder) throws {
        let sitePageElement = try SitePageElement(from: decoder)
        let id = sitePageElement.id
        let title = sitePageElement.title
        let siteId = sitePageElement.siteId
        let url = sitePageElement.url
        let siteType: SitePageController.Type
        if SitePage.mapPages[title] != nil {
            siteType = SitePage.mapPages[title]!
        } else {
            siteType = SitePage.mapPages[SitePage.defaultString]!
        }
        if title == "Assignments" {
            SakaiService.shared.siteAssignmentToolMap.updateValue(url, forKey: siteId)
        }
        self.init(id: id, title: title, siteId: siteId, siteType: siteType, url: url)
    }

    init(from serializedSitePage: PersistedSitePage) {
        let id = serializedSitePage.id
        let title = serializedSitePage.title
        let siteId = serializedSitePage.siteId
        let url = serializedSitePage.url
        let siteType: SitePageController.Type
        if SitePage.mapPages[title] != nil {
            siteType = SitePage.mapPages[title]!
        } else {
            siteType = SitePage.mapPages[SitePage.defaultString]!
        }
        self.init(id: id, title: title, siteId: siteId, siteType: siteType, url: url)
    }
}
