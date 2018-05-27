//
//  Term.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/11/18.
//

import Foundation

class Term {
    private static let mapTerms:[Int:String] = [1:"Spring", 9: "Fall", 6: "Summer 1", 7: "Summer 2", 12: "Winter"]
    
    private var year:Int?
    private var term:Int?
    private var termString:String?
    
    init(year:Int?, term:Int?, termString:String?) {
        self.year = year
        self.term = term
        self.termString = termString
    }
    
    convenience init(toParse: String?) {
        guard let tString = toParse else {
            self.init(year: nil, term: nil, termString: "None")
            return
        }
        
        let dataArray = tString.components(separatedBy: ":")
        guard let year = Int(dataArray[0]), let term = Int(dataArray[1]) else {
            self.init(year: nil, term: nil, termString: "None")
            return
        }
        self.init(year: year, term: term, termString: Term.mapTerms[term])
    }
    
    func getYear() -> Int? {
        return self.year
    }
    
    func getTerm() -> Int? {
        return self.term
    }
    
    func getTermString() -> String? {
        return self.termString
    }
    
    class func splitByTerms<T:TermSortable>(listToSort: [T]?) -> [[T]]? {
        guard var list = listToSort else {
            return nil
        }
        
        list.sort{$0.getTerm() > $1.getTerm()}
        
        var sectionList:[[T]] = [[T]]()
        
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

protocol TermSortable {
    func getTerm() -> Term
}




