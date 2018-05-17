//
//  SitePage.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/11/18.
//
import Foundation
import SwiftyJSON

class SitePage {
    
    private static let ANNOUNCEMENT_STRING:String = "Announcements"
    private static let ASSIGNMENTS_STRING:String  = "Assignments"
    private static let GRADEBOOK_STRING:String    = "Gradebook"
    private static let DEFAULT_STRING:String      = "None"
    
    private static let mapPages:[String:UIViewController.Type] = [ANNOUNCEMENT_STRING: AnnouncementController.self,
                                                        ASSIGNMENTS_STRING:  AssignmentController.self,
                                                        GRADEBOOK_STRING:    GradebookController.self,
                                                        DEFAULT_STRING:      DefaultController.self
    ]
    
    private var id:String
    private var title:String
    private var siteId:String
    private var siteType:Any
    
    init(_ id:String, _ title:String, _ siteId:String, _ siteType:Any) {
        self.id = id
        self.title = title
        self.siteId = siteId
        self.siteType = siteType
    }
    
    convenience init(data:JSON) {
        let id:String = data["id"].string!
        let title:String = data["title"].string!
        let siteId:String = data["siteId"].string!
        let siteType:UIViewController.Type
        if SitePage.mapPages[title] != nil {
            siteType = SitePage.mapPages[title]!
        } else {
            siteType = SitePage.mapPages[SitePage.DEFAULT_STRING]!
        }
        self.init(id, title, siteId, siteType)
    }
    
    func getId() -> String {
        return self.id
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getSiteId() -> String {
        return self.siteId
    }
    
    func getSiteType() -> Any {
        return self.siteType
    }
}
