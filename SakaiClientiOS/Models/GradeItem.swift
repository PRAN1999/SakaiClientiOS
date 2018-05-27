//
//  GradeItem.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/13/18.
//

import Foundation
import SwiftyJSON

class GradeItem: TermSortable, SiteSortable {
    
    private var grade:Double?
    private var points:Double
    private var title:String
    private var term:Term
    private var siteId:String
    
    init(_ grade:Double?, _ points:Double, _ title:String, _ term:Term, _ siteId:String) {
        self.grade = grade
        self.points = points
        self.title = title
        self.term = term
        self.siteId = siteId
    }
    
    convenience init(data: JSON, siteId:String) {
        let title = data["itemName"].string!
        let points = data["points"].double!
        var grade:Double?
        if data["grade"].string != nil {
            grade = Double(data["grade"].string!)
        }
        let term = AppGlobals.siteTermMap[siteId]!
        
        self.init(grade, points, title, term, siteId)
    }
    
    func getGrade() -> Double? {
        return self.grade
    }
    
    func getPoints() -> Double {
        return self.points
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getTerm() -> Term {
        return self.term
    }
    
    func getSiteId() -> String {
        return self.siteId
    }
    
}
