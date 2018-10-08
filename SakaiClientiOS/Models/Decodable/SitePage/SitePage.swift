//
//  SitePage.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/11/18.
//
import Foundation

/// A model for the individual subpages belonging to each Site
struct SitePage: Decodable {
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

    init(from decoder: Decoder) throws {
        let sitePageElement = try SitePageElement(from: decoder)
        self.id = sitePageElement.id
        self.title = sitePageElement.title
        self.siteId = sitePageElement.siteId
        self.url = sitePageElement.url
        let siteType: SitePageController.Type
        if SitePage.mapPages[title] != nil {
            siteType = SitePage.mapPages[title]!
        } else {
            siteType = SitePage.mapPages[SitePage.defaultString]!
        }
        self.siteType = siteType
        if title == "Assignments" {
            SakaiService.shared.siteAssignmentToolMap.updateValue(url, forKey: siteId)
        }
    }
}
