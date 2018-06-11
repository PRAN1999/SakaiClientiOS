//
//  Assignment.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/10/18.
//

import Foundation
import SwiftyJSON

class Assignment: TermSortable, SiteSortable {
    
    private var title:String
    private var dueTimeString:String
    private var term:Term
    private var siteId:String
    
    init(_ title:String, _ dueTimeString:String, _ term:Term, _ siteId:String) {
        self.title = title
        self.dueTimeString = dueTimeString
        self.term = term
        self.siteId = siteId
    }
    
    convenience init(data: JSON) {
        let title: String = data["title"].string!
        let dueTimeString: String = data["dueTimeString"].string!
        let siteId:String = data["context"].string!
        let term:Term = AppGlobals.siteTermMap[siteId]!
        self.init(title, dueTimeString, term, siteId)
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getDueTimeString() -> String {
        return self.dueTimeString
    }
    
    func getTerm() -> Term {
        return self.term
    }
    
    func getSiteId() -> String {
        return self.siteId
    }
}