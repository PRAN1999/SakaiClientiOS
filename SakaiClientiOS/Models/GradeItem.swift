//
//  GradeItem.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/13/18.
//

import Foundation
import SwiftyJSON

/**
 
 Represents a Gradebook entry for a user's gradebook
 
 Can be sorted by Term and by Site
 
 */

class GradeItem: TermSortable, SiteSortable {
    
    private var grade:Double?
    private var points:Double
    private var title:String
    private var term:Term
    private var siteId:String
    
    /**
     
     Instantiates a GradeItem with a grade and title for a specific Term and SiteId
     
     - Parameter grade: The points earned by the user on this gradebook entry
     - Parameter points: The maximum number of points the user can earn for this entry
     - Parameter title: The name of the gradebook entry
     - Parameter term: The Term to which this entry belongs
     - Parameter siteId: The siteId corresponding to the Site to which this entry belongs
     
     - Returns: a new GradeItem
     
     */
    
    init(_ grade:Double?, _ points:Double, _ title:String, _ term:Term, _ siteId:String) {
        self.grade = grade
        self.points = points
        self.title = title
        self.term = term
        self.siteId = siteId
    }
    
    /**
     
     Parses a JSON object that represents a Grade entry and instantiates a GradeItem accordingly
     
     - Parameter data: The JSON object containing the grade information
     - Parameter siteId: The siteId for the Site associated with this GradeItem
     
     */
    
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
    
    /**
     
     Gets grade of entry
     
     */
    func getGrade() -> Double? {
        return self.grade
    }
    
    /**
     
     Gets total possible points of entry
     
     */
    func getPoints() -> Double {
        return self.points
    }
    
    /**
     
     Gets title of grade entry
     
     */
    func getTitle() -> String {
        return self.title
    }
    
    /**
     
     Gets term associated with grade entry
     
     */
    func getTerm() -> Term {
        return self.term
    }
    
    /**
     
     Gets siteId associated with grade entry
     
     */
    func getSiteId() -> String {
        return self.siteId
    }
    
}
