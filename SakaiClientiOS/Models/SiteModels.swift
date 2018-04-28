//
//  Site.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//  Copyright © 2018 MAGNUMIUM. All rights reserved.
//

import Foundation
import SwiftyJSON

class Site {
    
    private var id:String;
    private var title:String;
    private var term:Term
    private var description:String?
    
    init(data:JSON) {
        self.id = data["id"].string!
        self.title = data["title"].string!
        
        let props = data["props"].dictionary!
        let termString:String? = props["term_eid"]?.string
        self.term = Term.getTerm(toParse: termString)
        
        self.description = stripHTML(description: data["description"].string)
    }
    
    private func stripHTML(description:String?) -> String? {
        guard let desc = description else {
            return nil
        }
        let str = desc.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return str
    }
    
    public func getId() -> String {
        return self.id
    }
    
    public func getTitle() -> String {
        return self.title
    }
    
    public func getTerm() -> Term {
        return self.term
    }
    
    public func getDescription() -> String? {
        return self.description
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

class Term {
    static let mapTerms:[Int:String] = [1:"Spring", 9: "Fall", 6: "Summer", 12: "Winter"]
    
    private var year:Int?
    private var term:Int?
    private var termString:String?
    
    init(year:Int?, term:Int?, termString:String?) {
        self.year = year
        self.term = term
        self.termString = termString
    }
    
    public class func getTerm(toParse:String?) -> Term {
        guard let tString = toParse else {
            return Term(year: nil, term: nil, termString: "None")
        }
        let dataArray = tString.components(separatedBy: ":")
        guard let year = Int(dataArray[0]), let term = Int(dataArray[1]) else {
            return Term(year: nil, term: nil, termString: "None")
        }
        return Term(year: year, term: term, termString: mapTerms[term])
    }
    
    public func getYear() -> Int? {
        return year
    }
    
    public func getTerm() -> Int? {
        return term
    }
    
    public func getTermString() -> String? {
        return termString
    }
}

extension Term:Comparable {
    static func < (lhs: Term, rhs:Term) -> Bool {
        guard let lYear = lhs.year, let lTerm = lhs.term else {
            return true
        }
        
        guard let rYear = rhs.year, let rTerm = rhs.term else {
            return false
        }
        
        if lYear < rYear {
            return true
        } else if lYear == rYear {
            return lTerm < rTerm
        }
        return false
    }
    
    static func == (lhs: Term, rhs: Term) -> Bool {
        guard let lYear = lhs.year, let lTerm = lhs.term else {
            guard let _ = rhs.year, let _ = rhs.term else {
                return true
            }
            return false
        }
        
        guard let rYear = rhs.year, let rTerm = rhs.term else {
            return false
        }
        
        return lYear == rYear && lTerm == rTerm
    }
    
    static func > (lhs: Term, rhs: Term) -> Bool {
        guard let lYear = lhs.year, let lTerm = lhs.term else {
            return false
        }
        
        guard let rYear = rhs.year, let rTerm = rhs.term else {
            return true
        }
        
        if lYear > rYear {
            return true
        } else if lYear == rYear {
            return lTerm > rTerm
        }
        return false
    }
}
