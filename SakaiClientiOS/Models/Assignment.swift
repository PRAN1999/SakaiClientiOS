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
    private var dueDate: Date
    private var instructions:String?
    private var attributedInstructions:NSAttributedString?
    private var term:Term
    private var siteId:String
    private var status:String?
    private var maxPoints:Double?
    private var currentGrade:Double?
    private var resubmissionAllowed:Bool?
    private var attachments:[NSAttributedString]?
    private var siteURL:String?
    
    private init(_ title:String, _ dueTimeString:String, _ dueDate: Date, _ term:Term, _ siteId:String, _ instructions: String?, _ attributedInstructions: NSAttributedString?, _ status:String?, _ maxPoints:Double?, _ currentGrade: Double?, _ resubmissionAllowed:Bool?, _ attachments: [NSAttributedString]?, _ siteURL: String?) {
        self.title = title
        self.dueTimeString = dueTimeString
        self.dueDate = dueDate
        self.term = term
        self.siteId = siteId
        self.instructions = instructions
        self.attributedInstructions = attributedInstructions
        self.status = status
        self.maxPoints = maxPoints
        self.currentGrade = currentGrade
        self.resubmissionAllowed = resubmissionAllowed
        self.attachments = attachments
        self.siteURL = siteURL
    }
    
    convenience init(data: JSON) {
        let title: String = data["title"].string!
        let dueTimeString: String = data["dueTimeString"].string!
        let time = data["dueTime"]["time"].double!
        let dueDate = Date(timeIntervalSince1970: time)
        let instructions: String? = data["instructions"].string
        let attributedInstructions:NSAttributedString? = instructions?.htmlAttributedString
        let siteId:String = data["context"].string!
        let term:Term = RequestManager.shared.siteTermMap[siteId]!
        let status:String? = data["status"].string
        var maxPoints:Double?
        if let pointString = data["gradeScaleMaxPoints"].string {
            maxPoints = Double(pointString)
        }
        
        let currentGrade:Double? = nil
        let resubmissionAllowed:Bool? = data["allowResubmission"].bool
        
        var attachmentStrings:[NSAttributedString] = [NSAttributedString]()
        if let attachmentObjects = data["attachments"].array {
            for attachmentObject in attachmentObjects {
                let text = attachmentObject["name"].string!
                let attachmentString = NSMutableAttributedString(string: text)
                
                let url = attachmentObject["url"].string!
                let range = NSRange(location: 0, length: text.count)
                attachmentString.addAttribute(.link, value: url, range: range)
                attachmentStrings.append(attachmentString)
            }
        }
        
        let siteURL = data["entityURL"].string
        
        self.init(title, dueTimeString, dueDate, term, siteId, instructions, attributedInstructions, status, maxPoints, currentGrade, resubmissionAllowed, attachmentStrings, siteURL)
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getDueTimeString() -> String {
        return dueTimeString
    }
    
    func getDueDate() -> Date {
        return dueDate
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
    
    func getAttachments() -> [NSAttributedString]? {
        return attachments
    }
    
    func getURL() -> String? {
        return siteURL
    }
}
