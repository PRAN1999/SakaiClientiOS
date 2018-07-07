//
//  Announcement.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/30/18.
//

import Foundation
import SwiftyJSON

struct Announcement: TermSortable, SiteSortable {
    
    let title:String?
    let term:Term
    let siteId:String
    
    init(_ title: String?,
         _ term:Term,
         _ siteId:String) {
        self.title = title
        self.term = term
        self.siteId = siteId
    }
    
    init(data: JSON) {
        let title = data["title"].string
        let siteId = data["siteId"].string!
        let term = DataHandler.shared.siteTermMap[siteId]!
        self.init(title, term, siteId)
    }
}
