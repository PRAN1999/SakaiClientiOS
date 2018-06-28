//
//  Assignment.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/10/18.
//

import Foundation
import SwiftyJSON

/// The model for an Assignment item
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
    
    /// Initializes a Assignment item with all relevant information. This initializer is for internal use only
    ///
    /// - Parameters:
    ///   - title: The title of the Assignment item
    ///   - dueTimeString: A String representing when the Assignment is due
    ///   - dueDate: The due date represented as a Date object
    ///   - term: The Term object to which the Assignment belongs to
    ///   - siteId: The siteId for the class to which the Assignment belongs
    ///   - instructions: The description for the Assignment and any instructions the instructor may have included. May include links and may include HTML tags and markdown
    ///   - attributedInstructions: The instructions for the Assignment after being parsed as HTML, to properly format links and other HTML tags
    ///   - status: The status for the Assignment; whether it is open or not
    ///   - maxPoints: The max grade possible for this assignment
    ///   - currentGrade: The current grade for the assignment if linked to gradebook. May be nil for most assignments
    ///   - resubmissionAllowed: A Boolean representing whether resubmission is allowed for the Assignment
    ///   - attachments: A List of attachments for the assignment, represented as NSAttributedString with embedded links to the content
    ///   - siteURL: A String containing the URL for the Assignment entity page, where Assignment submission can occur securely
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
    
    /// Uses a JSON object returned from network request and parses it to instantiate an Assignment object with all available fields
    ///
    /// - Parameter data: A JSON object representing a Sakai Assignment, which contains all relevant information for the assignment
    convenience init(data: JSON) {
        let title: String = data["title"].string!
        let dueTimeString: String = data["dueTimeString"].string!
        let time = data["dueTime"]["time"].double!
        let dueDate = Date(timeIntervalSince1970: time)
        let instructions: String? = data["instructions"].string
        let attributedInstructions:NSAttributedString? = instructions?.htmlAttributedString
        let siteId:String = data["context"].string!
        let term:Term = RequestManager.shared.siteTermMap[siteId]! //Use siteTermMap to fetch Term because assignment JSON doesn't contain that data
        let status:String? = data["status"].string
        var maxPoints:Double?
        if let pointString = data["gradeScaleMaxPoints"].string {
            maxPoints = Double(pointString)
        }
        
        let currentGrade:Double? = nil
        let resubmissionAllowed:Bool? = data["allowResubmission"].bool
        
        var attachmentStrings:[NSAttributedString] = [NSAttributedString]()
        if let attachmentObjects = data["attachments"].array {
            //Convert attachment into HTML attributed string with link to content through NSMutableAttributedString
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
    
    /// Gets the title of the Assignment
    ///
    /// - Returns: String
    func getTitle() -> String {
        return title
    }
    
    /// Gets the due time string
    ///
    /// - Returns: String
    func getDueTimeString() -> String {
        return dueTimeString
    }
    
    /// Gets the due date
    ///
    /// - Returns: Date
    func getDueDate() -> Date {
        return dueDate
    }
    
    /// Gets the raw instructions
    ///
    /// - Returns: String?
    func getInstructions() -> String? {
        return instructions
    }
    
    /// Gets the HTML parsed string
    ///
    /// - Returns: NSAttributedString?
    func getAttributedInstructions() -> NSAttributedString? {
        return attributedInstructions
    }
    
    /// Gets the Term for the Assignment
    ///
    /// - Returns: Term
    func getTerm() -> Term {
        return term
    }
    
    /// Gets the siteId for the Assignment
    ///
    /// - Returns: String
    func getSiteId() -> String {
        return siteId
    }
    
    /// Gets the Assignment status
    ///
    /// - Returns: String?
    func getStatus() -> String? {
        return status
    }
    
    /// Gets the max possible points
    ///
    /// - Returns: Double?
    func getMaxPoints() -> Double? {
        return maxPoints
    }
    
    /// Gets the current grade, if available
    ///
    /// - Returns: Double?
    func getCurrentGrade() -> Double? {
        return currentGrade
    }
    
    /// Gets whether resubmission is allowed
    ///
    /// - Returns: Bool?
    func getResubmission() -> Bool? {
        return resubmissionAllowed
    }
    
    /// Gets an array of attachments with links to content
    ///
    /// - Returns: [NSAttributedString]?
    func getAttachments() -> [NSAttributedString]? {
        return attachments
    }
    
    ///  Gets the URL for the Assignment entity
    ///
    /// - Returns: String?
    func getURL() -> String? {
        return siteURL
    }
}
