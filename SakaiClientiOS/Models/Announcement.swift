//
//  Announcement.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/30/18.
//

import Foundation
import SwiftyJSON

class Announcement: TermSortable, SiteSortable {
    
    private var title:String?
    private var term:Term
    private var siteId:String
    
    init(_ title: String?,
         _ term:Term,
         _ siteId:String) {
        self.title = title
        self.term = term
        self.siteId = siteId
    }
    
    convenience init(data: JSON) {
        let title = data["title"].string
        let siteId = data["siteId"].string!
        let term = DataHandler.shared.siteTermMap[siteId]!
        self.init(title, term, siteId)
    }
    
    func getTitle() -> String? {
        return title
    }
    
    func getTerm() -> Term {
        return term
    }
    
    func getSiteId() -> String {
        return siteId
    }
}
