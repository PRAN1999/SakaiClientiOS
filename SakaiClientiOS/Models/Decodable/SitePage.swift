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

    enum PageType {
        case gradebook, assignments, chatRoom, defaultPage, announcements, resources
    }

    /// A map to provide native interfaces for common site pages shared by most classes
    private static let mapPages: [String: (PageType, SitePageController.Type)] = [
        assignmentsString:  (.assignments, SiteAssignmentController.self),
        gradebookString:    (.gradebook, SiteGradebookController.self),
        chatRoomString:     (.chatRoom, ChatRoomController.self),
        defaultString:      (.defaultPage, DefaultController.self),
        resourcesString:    (.resources, ResourcePageController.self),
        announcementString: (.announcements, SiteAnnouncementController.self)
    ]

    let id: String
    let title: String
    let siteId: String
    let siteType: SitePageController.Type
    let pageType: PageType
    let url: String
}

extension SitePage: Decodable {
    init(from decoder: Decoder) throws {
        let sitePageElement = try SitePageElement(from: decoder)
        let id = sitePageElement.id
        let title = sitePageElement.title
        let siteId = sitePageElement.siteId
        let url = sitePageElement.url
        var siteType: SitePageController.Type = DefaultController.self
        var pageType = PageType.defaultPage
        if let (page, type) = SitePage.mapPages[title] {
            siteType = type
            pageType = page
        }
        if pageType == .assignments {
            SakaiService.shared.setAssignmentToolUrl(url: url, siteId: siteId)
        }
        self.init(id: id, title: title, siteId: siteId, siteType: siteType, pageType: pageType, url: url)
    }

    init(from serializedSitePage: PersistedSitePage) {
        let id = serializedSitePage.id
        let title = serializedSitePage.title
        let siteId = serializedSitePage.siteId
        let url = serializedSitePage.url
        var siteType: SitePageController.Type = DefaultController.self
        var pageType = PageType.defaultPage
        if let (page, type) = SitePage.mapPages[title] {
            siteType = type
            pageType = page
        }
        if pageType == .assignments {
            SakaiService.shared.setAssignmentToolUrl(url: url, siteId: siteId)
        }
        self.init(id: id, title: title, siteId: siteId, siteType: siteType, pageType: pageType, url: url)
    }
}
