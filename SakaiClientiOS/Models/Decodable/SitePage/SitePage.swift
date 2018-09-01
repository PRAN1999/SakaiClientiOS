//
//  SitePage.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/11/18.
//
import Foundation

/// SitePage represents the subpages of each Sakai site
struct SitePage: Decodable {
    // swiftlint:disable identifier_name
    private static let ANNOUNCEMENT_STRING: String = "Announcements"
    private static let ASSIGNMENTS_STRING: String  = "Assignments"
    private static let GRADEBOOK_STRING: String    = "Gradebook"
    private static let RESOURCES_STRING: String    = "Resources"
    private static let CHAT_ROOM_STRING: String    = "Chat Room"
    private static let DEFAULT_STRING: String      = "None"

    /// A map for the common site pages shared by most classes
    private static let mapPages: [String: SitePageController.Type] = [
        ANNOUNCEMENT_STRING: SiteAnnouncementController.self,
        ASSIGNMENTS_STRING: SiteAssignmentController.self,
        GRADEBOOK_STRING: SiteGradebookController.self,
        RESOURCES_STRING: ResourcePageController.self,
        CHAT_ROOM_STRING: ChatRoomController.self,
        DEFAULT_STRING: DefaultController.self
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
            siteType = SitePage.mapPages[SitePage.DEFAULT_STRING]!
        }
        self.siteType = siteType
        if title == "Assignments" {
            SakaiService.shared.siteAssignmentToolMap.updateValue(url, forKey: siteId)
        }
    }
}
