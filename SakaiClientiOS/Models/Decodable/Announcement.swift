//
//  Announcement.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/30/18.
//

import Foundation

/// A model for the Announcement item
struct Announcement: Decodable, TermSortable, SiteSortable {

    let author: String
    let title: String?
    let content: String?
    let term: Term
    let siteId: String
    let date: Date
    let dateString: String
    let attachments: [AttachmentElement]?

    var attributedContent: NSAttributedString?

    init(from decoder: Decoder) throws {
        let announcementElement = try AnnouncementElement(from: decoder)
        self.author = announcementElement.author
        self.title = announcementElement.title
        self.content = announcementElement.content
        self.siteId = announcementElement.siteId
        self.date = announcementElement.date
        self.dateString = String.getDateString(date: date)
        self.attachments = announcementElement.attachments
        guard let term = SakaiService.shared.siteTermMap[siteId] else {
            throw SakaiError.parseError("No valid Term found")
        }
        self.term = term
    }

    mutating func setAttributedContent() {
        attributedContent = content?.htmlAttributedString
    }
}
