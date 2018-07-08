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
    
    init(_ author: String,
         _ title: String?,
         _ content: String?,
         _ attributedContent: NSAttributedString?,
         _ term:Term,
         _ siteId:String,
         _ date: Date,
         _ dateString: String) {
        self.author = author
        self.title = title
        self.content = content
        self.attributedContent = attributedContent
        self.term = term
        self.siteId = siteId
        self.date = date
        self.dateString = dateString
    }
    
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
        self.init(author, title, content, attributedContent, term, siteId, date, dateString)
    }
}
