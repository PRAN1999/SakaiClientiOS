//
//  Site.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.//

import Foundation
import SwiftyJSON

/**
 
 A protocol for objects that can be sorted by Site and have a siteId
 
 */
protocol SiteSortable {
    
    var siteId:String { get }
}

/**
 
 A struct to represent a user Site object.
 
 Can be sorted by Term
 
 */
struct Site: TermSortable {
    
    let id          :String
    let title       :String
    let term        :Term
    let description :String?
    let pages       :[SitePage]
    
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
    private init(_ id           :String,
                 _ title        :String,
                 _ term         :Term,
                 _ description  :String? = nil,
                 _ pages        :[SitePage]) {
        self.id             = id
        self.title          = title
        self.term           = term
        self.description    = description
        self.pages          = pages
    }
    
    /**
     
     Takes a JSON object that represents a Site and parses it for specifications specific to Site before initializing Site object
     
     - parameters:
        - data: JSON object representing Site from HTTP call
     
     - returns:
     A Site object
     
     */
    init(data:JSON) {
        let id          = data["id"].string!
        let title       = data["title"].string!
        let props       = data["props"].dictionary!
        let termString  = props["term_eid"]?.string
        let term        = Term(toParse: termString)
        let description = data["description"].string
        let pages       = data["sitePages"].array!
        
        var sitePages   = [SitePage]()
        for page in pages {
            sitePages.append(SitePage(data: page))
        }
        
        self.init(id, title, term, description, sitePages)
    }
    
    /**
     
     Sorts and splits an array of T:SiteSortable items by siteid and returns a 2-dimensional array of T where each sub-array represents the items for a specific Site
     
     - Parameter listToSort: The [T:SiteSortable] array that needs to be sorted by Site
     
     - Returns: A two-dimensional array of T split by siteId
     
    */
    static func splitBySites<T:SiteSortable>(listToSort:[T]?) -> [[T]]? {
        guard let list = listToSort else {
            return nil
        }
        
        var sortedList:[[T]] = [[T]]()
        
        //Maintain a map of site Id's to array indices so items can be added to the correct inner array
        //This is because Site's cannot be compared like Terms, and therefore have to be split
        var mapSiteIdToIndex:[String:Int] = [:]
        var i:Int = 0
        
        let numItems:Int = list.count
        
        for index in 0..<numItems {
            let sortableItem:T = list[index]
            
            if let index = mapSiteIdToIndex[sortableItem.siteId] {
                //If the siteId exists in the dictionary, add the SiteSortable item to the corresponding inner array
                sortedList[index].append(sortableItem)
            } else {
                //If the siteId does not exist in the dictionary, add it to the dictionary and update the next open index count
                mapSiteIdToIndex.updateValue(i, forKey: sortableItem.siteId)
                sortedList.append([T]())
                sortedList[i].append(sortableItem)
                i += 1
            }
        }
        
        return sortedList
    }
}


