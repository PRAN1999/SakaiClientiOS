//
//  Site.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.//

import Foundation
import SwiftyJSON

class Site: TermSortable {
    
    private var id:String;
    private var title:String;
    private var term:Term
    private var description:String?
    private var pages:[SitePage]
    
    init(_ id:String, _ title:String, _ term:Term, _ description: String?, _ pages:[SitePage]) {
        self.id = id
        self.title = title
        self.term = term
        self.description = description
        self.pages = pages
    }
    
    convenience init(data:JSON) {
        let id = data["id"].string!
        let title = data["title"].string!
        
        let props = data["props"].dictionary!
        let termString:String? = props["term_eid"]?.string
        let term = Term(toParse: termString)
        
        let description = data["description"].string
        
        let pages = data["sitePages"].array!
        var sitePages:[SitePage] = []
        for page in pages {
            sitePages.append(SitePage(data: page))
        }
        
        self.init(id, title, term, description, sitePages)
    }
    
    func getId() -> String {
        return self.id
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getTerm() -> Term {
        return self.term
    }
    
    func getDescription() -> String? {
        return self.description
    }
    
    func getPages() -> [SitePage] {
        return self.pages
    }
    
    class func splitBySites<T:SiteSortable>(listToSort:[T]?) -> [[T]]? {
        guard let list = listToSort else {
            return nil
        }
        
        var sortedList:[[T]] = [[T]]()
        
        var mapSiteIdToIndex:[String:Int] = [:]
        var i:Int = 0
        
        let numItems:Int = list.count
        
        for index in 0..<numItems {
            let sortableItem:T = list[index]
            
            if let index = mapSiteIdToIndex[sortableItem.getSiteId()] {
                sortedList[index].append(sortableItem)
            } else {
                mapSiteIdToIndex.updateValue(i, forKey: sortableItem.getSiteId())
                sortedList.append([T]())
                sortedList[i].append(sortableItem)
                i += 1
            }
        }
        
        return sortedList
    }
}

protocol SiteSortable {
    func getSiteId() -> String
}


