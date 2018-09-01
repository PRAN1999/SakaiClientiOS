//
//  RawAnnouncement.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/31/18.
//

import Foundation

struct AnnouncementCollection: Decodable {
    let announcementCollection: [Announcement]

    enum CodingKeys: String, CodingKey {
        case announcementCollection = "announcement_collection"
    }
}

struct AnnouncementElement: Decodable {
    let author: String
    let title: String?
    let content: String?
    let siteId: String
    let date: Date
    let attachments: [AttachmentElement]?

    enum CodingKeys: String, CodingKey {
        case author = "createdByDisplayName"
        case title
        case content = "body"
        case siteId
        case date = "createdOn"
        case attachments
    }
}
