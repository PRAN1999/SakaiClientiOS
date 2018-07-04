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
    
    private init(_ grade:Double? = nil,
                 _ points:Double,
                 _ title:String,
                 _ term:Term,
                 _ siteId:String) {
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
        //Get term from shared dictionary because Grade json data doesn't have term data
        let term = DataHandler.shared.siteTermMap[siteId]!
        
        self.init(grade, points, title, term, siteId)
    }
    
    /**
     
     Gets grade of entry
     
     */
    func getGrade() -> Double? {
        return grade
    }
    
    /**
     
     Gets total possible points of entry
     
     */
    func getPoints() -> Double {
        return points
    }
    
    /**
     
     Gets title of grade entry
     
     */
    func getTitle() -> String {
        return title
    }
    
    /**
     
     Gets term associated with grade entry
     
     */
    func getTerm() -> Term {
        return term
    }
    
    /**
     
     Gets siteId associated with grade entry
     
     */
    func getSiteId() -> String {
        return siteId
    }
    
}
