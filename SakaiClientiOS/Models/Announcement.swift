//
//  Announcement.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/30/18.
//

import Foundation
import SwiftyJSON

struct Announcement: TermSortable, SiteSortable {
    
    let author:String
    let title:String?
    let content: String?
    let attributedContent: NSAttributedString?
    let term:Term
    let siteId:String
    let date:Date
    let dateString:String
    let attachments:[NSAttributedString]?
    
    /// Instantiates an Announcement object with relevant fields
    ///
    /// - Parameters:
    ///   - author: The author of the Announcement
    ///   - title: The title of the Announcement
    ///   - content: The message body of the Announcement. Is often in html or similar raw format
    ///   - attributedContent: The parsed message body to display to the user
    ///   - term: The Term to which the Announcement belongs
    ///   - siteId: The siteId corresponding to the Site to which this Announcement belongs
    ///   - date: The date-time when the Announcement was published
    ///   - dateString: The string to display to inform user of when this Announcment was published. Use custom date string parser in Parser.swift to display information in the correct format
    init(_ author: String,
         _ title: String?,
         _ content: String?,
         _ attributedContent: NSAttributedString?,
         _ term:Term,
         _ siteId:String,
         _ date: Date,
         _ dateString: String,
         _ attachments: [NSAttributedString]?) {
        self.author = author
        self.title = title
        self.content = content
        self.attributedContent = attributedContent
        self.term = term
        self.siteId = siteId
        self.date = date
        self.dateString = dateString
        self.attachments = attachments
    }
    
    /// Uses a JSON object returned from network request and parses it to instantiate an Announcement object with all available fields
    ///
    /// - Parameter data: A JSON object representing a Sakai Announcement, which contains all relevant information for the assignment
    init(data: JSON) {
        let author = data["createdByDisplayName"].string!
        let title = data["title"].string
        let content = data["body"].string
        let attributedContent = content?.htmlAttributedString
        let siteId = data["siteId"].string!
        let term = DataHandler.shared.siteTermMap[siteId]!
        let time = data["createdOn"].double! / 1000
        let date = Date(timeIntervalSince1970: time)
        let dateString = String.getDateString(date: date)
        
        var attachmentStrings:[NSAttributedString] = [NSAttributedString]()
        if let attachmentObjects = data["attachments"].array {
            //Convert attachment into HTML attributed string with link to content through NSMutableAttributedString
            for attachmentObject in attachmentObjects {
                let text = attachmentObject["name"].string!
                let attachmentString = NSMutableAttributedString(string: text)
                
                let url = attachmentObject["url"].string!
                let range = NSRange(location: 0, length: text.count)
                attachmentString.addAttribute(.link, value: url, range: range)
                attachmentStrings.append(attachmentString)
            }
        }
        self.init(author, title, content, attributedContent, term, siteId, date, dateString, attachmentStrings)
    }
}
