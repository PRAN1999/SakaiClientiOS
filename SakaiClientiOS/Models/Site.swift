//
//  Site.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.//

import Foundation
import SwiftyJSON

/**
 
 A class to represent a user Site object.
 
 Can be sorted by Term
 
 */
class Site: TermSortable {
    
    ///The unique String id for a Site
    private var id:String;
    
    ///The title or name of a Site
    private var title:String;
    
    ///The Term of a Site
    private var term:Term
    
    ///The String description of a Site
    private var description:String?
    
    ///The unique SitePage objects for each individual Site
    private var pages:[SitePage]
    
    /**
     
     Initializes a Site object with the provided specifications
     
     - parameters:
         - id: The unique String identifier for a Site
         - title: The title or name of the Site
         - term: The Term during which this Site was active
         - description: A description of the Site's content
         - pages: An array of SitePages unique to the Site
     
     - returns:
     A Site object
     
     */
    private init(_ id:String, _ title:String, _ term:Term, _ description: String?, _ pages:[SitePage]) {
        self.id = id
        self.title = title
        self.term = term
        self.description = description
        self.pages = pages
    }
    
    /**
     
     Takes a JSON object that represents a Site and parses it for specifications specific to Site before initializing Site object
     
     - parameters:
        - data: JSON object representing Site from HTTP call
     
     - returns:
     A Site object
     
     */
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
    
    /**
 
    Gets the unique id for the Site

    */
    func getId() -> String {
        return id
    }
    
    /**
     
     Gets the title for the Site
     
    */
    func getTitle() -> String {
        return title
    }
    
    /**
     
     Gets the Term for the Site
     
     */
    func getTerm() -> Term {
        return term
    }
    
    /**
     
     Gets the description for the Site
     
     */
    func getDescription() -> String? {
        return description
    }
    
    /**
     
     Gets the SitePages for the Site
     
     */
    func getPages() -> [SitePage] {
        return pages
    }
    
    /**
     
     Sorts and splits an array of T:SiteSortable items by siteid and returns a 2-dimensional array of T where each sub-array represents the items for a specific Site
     
     - Parameter listToSort: The [T:SiteSortable] array that needs to be sorted by Site
     
     - Returns: A two-dimensional array of T split by siteId
     
    */
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

/**
 
 A protocol for objects that can be sorted by Site and have a siteId
 
 */
protocol SiteSortable {
    
    /**
     
     Return the siteId for the implementation
     
     */
    func getSiteId() -> String
}


