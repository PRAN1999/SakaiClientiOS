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
        case gradebook, assignments, chatRoom
        case defaultPage, announcements, resources
    }

    /// A map to determine if a page has native support or should be
    /// opened in a webview
    private static let mapPages: [String: PageType]
        = [
        assignmentsString: .assignments,
        gradebookString: .gradebook,
        chatRoomString: .chatRoom,
        defaultString: .defaultPage,
        resourcesString: .resources,
        announcementString: .announcements
    ]

    let id: String
    let title: String
    let siteId: String
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
        var pageType = PageType.defaultPage
        if let type = SitePage.mapPages[title] {
            pageType = type
        }
        self.init(id: id,
                  title: title,
                  siteId: siteId,
                  pageType: pageType,
                  url: url)
    }

    init(from serializedSitePage: PersistedSitePage) {
        let id = serializedSitePage.id
        let title = serializedSitePage.title
        let siteId = serializedSitePage.siteId
        let url = serializedSitePage.url
        var pageType = PageType.defaultPage
        if let type = SitePage.mapPages[title] {
            pageType = type
        }
        if pageType == .assignments {
            SakaiService.shared.setAssignmentToolUrl(url: url, siteId: siteId)
        }
        self.init(id: id,
                  title: title,
                  siteId: siteId,
                  pageType: pageType,
                  url: url)
    }
}
