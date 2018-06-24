//
//  Assignment.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/10/18.
//

import Foundation
import SwiftyJSON

class Assignment: TermSortable, SiteSortable {
    
    private var title:String
    private var dueTimeString:String
    private var instructions:String?
    private var attributedInstructions:NSAttributedString?
    private var term:Term
    private var siteId:String
    private var status:String?
    private var maxPoints:Double?
    private var currentGrade:Double?
    private var resubmissionAllowed:Bool?
    
    init(_ title:String, _ dueTimeString:String, _ term:Term, _ siteId:String, _ instructions: String?, _ attributedInstructions: NSAttributedString?, _ status:String?, _ maxPoints:Double?, _ currentGrade: Double?,
         _ resubmissionAllowed:Bool?) {
        self.title = title
        self.dueTimeString = dueTimeString
        self.term = term
        self.siteId = siteId
        self.instructions = instructions
        self.attributedInstructions = attributedInstructions
        self.status = status
        self.maxPoints = maxPoints
        self.currentGrade = currentGrade
        self.resubmissionAllowed = resubmissionAllowed
    }
    
    convenience init(data: JSON) {
        let title: String = data["title"].string!
        let dueTimeString: String = data["dueTimeString"].string!
        let instructions: String? = data["instructions"].string
        let attributedInstructions:NSAttributedString? = instructions?.htmlAttributedString
        let siteId:String = data["context"].string!
        let term:Term = AppGlobals.siteTermMap[siteId]!
        let status:String? = data["status"].string
        var maxPoints:Double?
        if let pointString = data["gradeScaleMaxPoints"].string {
            maxPoints = Double(pointString)
        }
        var currentGrade:Double?
        let resubmissionAllowed:Bool? = data["allowResubmission"].bool
        self.init(title, dueTimeString, term, siteId, instructions, attributedInstructions, status, maxPoints, currentGrade, resubmissionAllowed)
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getDueTimeString() -> String {
        return dueTimeString
    }
    
    func getInstructions() -> String? {
        return instructions
    }
    
    func getAttributedInstructions() -> NSAttributedString? {
        return attributedInstructions
    }
    
    func getTerm() -> Term {
        return term
    }
    
    func getSiteId() -> String {
        return siteId
    }
    
    func getStatus() -> String? {
        return status
    }
    
    func getMaxPoints() -> Double? {
        return maxPoints
    }
    
    func getCurrentGrade() -> Double? {
        return currentGrade
    }
    
    func getResubmission() -> Bool? {
        return resubmissionAllowed
    }
}
