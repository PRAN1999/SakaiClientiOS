//
//  Term.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/11/18.
//

import Foundation

/**
 
 A protocol implemented by objects that can be sorted by Term
 
 */
protocol TermSortable {
    
    var term:Term { get }
}


/**
 
 A struct to represent individual semesters following the Rutgers academic schedule through the years
 
 */

struct Term {
    private static let mapTerms:[Int:String] = [1:"Spring", 9: "Fall", 6: "Summer 1", 7: "Summer 2", 12: "Winter"]
    
    let year:Int?
    let termInt:Int?
    let termString:String?
    
    /**
 
    Instantiate a term object with the specified characteristics
     
    - Parameter year: The year during which the term occurred
    - Parameter termInt: The first month of the academic semester corresponding to the term
    - Parameter termString: The description of the term
     
    - Returns: A Term object
     
     */
    private init(year:Int?, termInt:Int?, termString:String?) {
        self.year = year
        self.termInt = termInt
        self.termString = termString
    }
    
    /**
 
    Parses a String containing the term and the year to construct a Term object with the corresponding attributes
     
     - Parameter toParse: A String with the format "{termInt}:{year}" like "1:2018"
     
    - Returns: A Term object
     
     */
    init(toParse: String?) {
        guard let tString = toParse else {
            self.init(year: nil, termInt: nil, termString: "None")
            return
        }
        
        let dataArray = tString.components(separatedBy: ":")
        guard let year = Int(dataArray[0]), let term = Int(dataArray[1]) else {
            self.init(year: nil, termInt: nil, termString: "None")
            return
        }
        self.init(year: year, termInt: term, termString: Term.mapTerms[term])
    }
    
    /**
     
     Gets the full String representation of the Term: i.e "Spring 2018"
     
     */
    func getTitle() -> String {
        guard let string = self.termString, let year = self.year else {
            return "General"
        }
        return "\(string) \(year)"
    }
    
    /**
    
     Takes an array of T:TermSortable and splits it by Term by putting every item with the same Term in the same array and then returning a 2-dimensional array consisting of those arrays
     
     - Parameter listToSort: An array of T:TermSortable to be split by Term
     
     - Returns: A 2-dimensional array of T:TermSortable with each sub-array corresponding to a Term
     
     Sorts the array by Term and then walks through array building separate arrays
     
     */
    static func splitByTerms<T:TermSortable>(listToSort: [T]?) -> [[T]]? {
        guard var list = listToSort else {
            return nil
        }
        
        list.sort{$0.term > $1.term}
        
        var sectionList:[[T]] = [[T]]()
        
        var terms:[Term] = [Term]()
        var indices:[Int] = [Int]()
        
        for index in 0..<list.count {
            if !terms.contains(list[index].term) {
                terms.append(list[index].term)
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
    
    /**
    
     Compares termInt and year to determine if left Term is less than right Term
     
     */
    static func < (lhs: Term, rhs:Term) -> Bool {
        
        guard let lYear = lhs.year, let lTerm = lhs.termInt else {
            return true
        }
        
        guard let rYear = rhs.year, let rTerm = rhs.termInt else {
            return false
        }
        
        if lYear < rYear {
            return true
        } else if lYear == rYear {
            return lTerm < rTerm
        }
        return false
    }
    
    /**
     
     Compares termInt and year to determine if left Term is greater than right Term
     
     */
    static func == (lhs: Term, rhs: Term) -> Bool {
        guard let lYear = lhs.year, let lTerm = lhs.termInt else {
            guard let _ = rhs.year, let _ = rhs.termInt else {
                return true
            }
            return false
        }
        
        guard let rYear = rhs.year, let rTerm = rhs.termInt else {
            return false
        }
        
        return lYear == rYear && lTerm == rTerm
    }
    
    /**
     
     Compares termInt and year to determine if left Term is equal to right Term
     
     */
    static func > (lhs: Term, rhs: Term) -> Bool {
        guard let lYear = lhs.year, let lTerm = lhs.termInt else {
            return false
        }
        
        guard let rYear = rhs.year, let rTerm = rhs.termInt else {
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




