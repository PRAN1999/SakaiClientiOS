//
//  Announcement.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/30/18.
//

import Foundation

class Announcement: TermSortable, SiteSortable {
    
    private var term:Term
    private var siteId:String
    
    init(_ term:Term, _ siteId:String) {
        self.term = term
        self.siteId = siteId
    }
    
    func getTerm() -> Term {
        return term
    }
    
    func getSiteId() -> String {
        return siteId
    }
}
