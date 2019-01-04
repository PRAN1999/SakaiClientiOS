//
//  Announcement.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/30/18.
//

import Foundation

/// A model for the Announcement item
struct Announcement: TermSortable, SiteSortable {

    let author: String
    let title: String?
    let content: String?
    let term: Term
    let siteId: String
    let date: Date
    let dateString: String
    let attachments: [AttachmentElement]?
    let subjectCode: Int?

    var attributedContent: NSAttributedString?

    mutating func setAttributedContent() {
        attributedContent = content?.htmlAttributedString
    }
}

extension Announcement: Decodable {
    init(from decoder: Decoder) throws {
        let announcementElement = try AnnouncementElement(from: decoder)
        let author = announcementElement.author
        let title = announcementElement.title
        let content = announcementElement.content
        let siteId = announcementElement.siteId
        let date = announcementElement.date
        let dateString = String.getDateString(date: date)
        let attachments = announcementElement.attachments
        guard let term = SakaiService.shared.siteTermMap[siteId] else {
            throw SakaiError.parseError("No valid Term found")
        }
        let code = SakaiService.shared.siteSubjectCode[siteId]
        self.init(author: author,
                  title: title,
                  content: content,
                  term: term,
                  siteId: siteId,
                  date: date,
                  dateString: dateString,
                  attachments: attachments,
                  subjectCode: code,
                  attributedContent: nil)
    }
}
