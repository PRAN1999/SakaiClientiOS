//
//  SitePage.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/11/18.
//
import Foundation
import SwiftyJSON

///SitePage represents the subpages of each Sakai site
struct SitePage {
    
    private static let ANNOUNCEMENT_STRING:String = "Announcements"
    private static let ASSIGNMENTS_STRING:String  = "Assignments"
    private static let GRADEBOOK_STRING:String    = "Gradebook"
    private static let DEFAULT_STRING:String      = "None"
    
    /// A map for the common site pages shared by most classes
    private static let mapPages:[String:UIViewController.Type] = [ANNOUNCEMENT_STRING: SiteAnnouncementController.self,
                                                                  ASSIGNMENTS_STRING:  AssignmentController.self,
                                                                  GRADEBOOK_STRING:    SiteGradebookController.self,
                                                                  DEFAULT_STRING:      DefaultController.self
    ]
    
    let id:String
    let title:String
    let siteId:String
    let siteType:UIViewController.Type
    
    /// Initializes a SitePage object with defined parameters
    ///
    /// - Parameters:
    ///   - id: The unique id for the SitePage
    ///   - title: The name of the SitePage
    ///   - siteId: The id for the Site to which the SitePage belongs
    ///   - siteType: A ViewController type detailing whether the SitePage is a defined default type
    private init(_ id:String,
                 _ title:String,
                 _ siteId:String,
                 _ siteType:UIViewController.Type) {
        self.id = id
        self.title = title
        self.siteId = siteId
        self.siteType = siteType
    }
    
    /// A convenient initializer to take a JSON object and parses it to construct a SitePage
    ///
    /// - Parameter data: The JSON object containing all the information for a SitePage
    init(data:JSON) {
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
}
