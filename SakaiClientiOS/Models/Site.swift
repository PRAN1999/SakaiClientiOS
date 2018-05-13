//
//  Site.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.//

import Foundation
import SwiftyJSON

class Site {
    
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
    
    class func splitByTerms(siteList:[Site]?) -> [[Site]]? {
        guard var list = siteList else {
            return nil
        }
        
        list.sort{$0.getTerm() > $1.getTerm()}
        
        var sectionList:[[Site]] = [[Site]]()
        
        var terms:[Term] = [Term]()
        var indices:[Int] = [Int]()
        
        for index in 0..<list.count {
            if !terms.contains(list[index].getTerm()) {
                terms.append(list[index].getTerm())
                indices.append(index)
            }
        }
        
        var i:Int = 0
        for index in 0..<indices.count {
            let slice = list[i..<indices[index]]
            sectionList.append(Array(slice))
            i = indices[index]
        }
        
        sectionList.append(Array(list[i..<list.count]))
        sectionList.remove(at: 0)
        
        return sectionList
    }
}


