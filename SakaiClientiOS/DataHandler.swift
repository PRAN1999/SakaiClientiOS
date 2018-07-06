//
//  DataHandler.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/2/18.
//

import Foundation
import SwiftyJSON

class DataHandler {
    
    static let shared = DataHandler()
    
    ///A dictionary mapping siteID's for all the user Site's to their respective Term objects.
    ///
    ///For use in Assignment model and GradeItem model
    var siteTermMap:[String: Term] = [:]
    
    ///A dictionary mapping siteID's for all the user Site's to the respective Site name.
    ///
    ///For use in SiteAssignmentDataSource when setting site title
    var siteTitleMap:[String:String] = [:]
    
    private init() {}
    
    func reset() {
        siteTermMap = [:]
        siteTitleMap = [:]
    }
    
    /**
     
     Makes an HTTP request to determine the list of sites the user is registered for. Instantiates and sorts Sites by Term to construct 2-dimensional array of sites. That array is passed into completion handler for callee to use as needed. Also sets AppGlobal variables to be used throughout app by mapping siteId to Term and to site title
     
     - parameter completion: A closure called with a [[Site]] object to be implemented by callee
     - parameter site: A [[Site]] object passed into closure for callee to use as needed
     
     */
    func getSites(completion: @escaping (_ site: [[Site]]?) -> Void) {
        RequestManager.shared.makeRequest(url: AppGlobals.SITES_URL, method: .get) { response in
            
            //print(response)
            guard let data = response.result.value else {
                print("error")
                return
            }
            
            var siteList:[Site] = [Site]()
            guard let sitesJSON = JSON(data)["site_collection"].array else { //Ensure the JSON date has a "site_collection" array
                completion(nil)
                return
            }
            
            for siteJSON in sitesJSON {
                let site:Site! = Site(data: siteJSON) //Construct a Site from a JSON object
                siteList.append(site)
                
                //Update shared map for siteId : Term
                //                      siteId : Title
                self.siteTermMap.updateValue(site.getTerm(), forKey: site.getId())
                self.siteTitleMap.updateValue(site.getTitle(), forKey: site.getId())
            }
            let sectionList = Term.splitByTerms(listToSort: siteList) //Split the site list by Term
            
            completion(sectionList)
        }
    }
    
    /**
     
     Makes HTTP request to get gradebook items for specfic site and constructs array of GradeItem to pass into closure
     
     - parameters:
     - siteId: The siteId representing the site for which grades should be fetched
     - completion: A closure called with a [GradeItem] object to be implemented by callee
     - grades: The [GradeItem] object constructed with response and passed to closure
     
     */
    func getSiteGrades(siteId:String, completion: @escaping (_ grades: [GradeItem]?) -> Void) {
        let url:String = AppGlobals.SITE_GRADEBOOK_URL.replacingOccurrences(of: "*", with: siteId)
        RequestManager.shared.makeRequest(url: url, method: .get) { response in
            guard let data = response.result.value else {
                print("error")
                return
            }
            
            var gradeList:[GradeItem] = [GradeItem]()
            guard let gradesJSON = JSON(data)["assignments"].array else { //Ensure the JSON data has an "assignments" array
                completion(nil)
                return
            }
            
            for gradeJSON in gradesJSON {
                //Construct a GradeItem object and add it to the gradeList
                gradeList.append(GradeItem(data: gradeJSON, siteId: siteId))
            }
            
            completion(gradeList)
        }
    }
    
    /**
     
     An HTTP request is made to fetch all grades for all user Sites. The response is parsed into GradeItem objects and are sorted first by Term and then by Site to ultimately pass a 3-dim array [[[GradeItem]]] into the completion handler
     
     This method is called by the GradebookDataSource
     
     - parameters:
     - completion: A closure called with a [[[GradeItem]]] object to be implemented by callee
     - grades: The [[[Gradeitem]]] object constructed with response and passed into closure
     
     */
    func getAllGrades(completion: @escaping (_ grades: [[[GradeItem]]]?) -> Void) {
        let url:String = AppGlobals.GRADEBOOK_URL
        RequestManager.shared.makeRequest(url: url, method: .get) { response in
            guard let data = response.result.value else {
                print("error")
                return
            }
            
            //Ensure the JSON data has an "gradebook_collection" array
            guard let collection = JSON(data)["gradebook_collection"].array else {
                completion(nil)
                return
            }
            
            var gradeList:[GradeItem] = [GradeItem]()
            
            for site in collection {
                //Every object within the collection has general site data with an "assignments" array that represents the gradebook
                guard let assignments = site["assignments"].array else {
                    completion(nil)
                    return
                }
                let siteId:String = site["siteId"].string!
                for assignment in assignments {
                    gradeList.append(GradeItem(data: assignment, siteId: siteId))
                }
                
            }
            
            //Sort gradeList by Term
            guard let termSortedGrades = Term.splitByTerms(listToSort: gradeList) else {
                completion(nil)
                return
            }
            var sortedGrades:[[[GradeItem]]] = [[[GradeItem]]]()
            let numTerms:Int = termSortedGrades.count
            
            //For each term-specific gradeList, sort by Site and insert into 3-dim array
            for index in 0..<numTerms {
                sortedGrades.append(Site.splitBySites(listToSort: termSortedGrades[index])!)
            }
            
            completion(sortedGrades)
        }
    }
    
    /// Makes a request to retrieve all assignment data for a user and then parses them into Assignment objects. Then it splits Assignment's by Term and Site, and then sorts each innermost array by Due Date to pass [[[Assignment]]] object into completion handler
    ///
    /// This method is called by SiteAssignmentDataSource
    ///
    /// - Parameter completion: A closure called with a 3-dimensional Assignment array to be implemented by caller
    /// - Parameter assignments: The 3-dimensional array of Assignments to be passed into the completion handler
    func getAllAssignmentsBySites(completion: @escaping (_ assignments: [[[Assignment]]]?) -> Void) {
        let url:String = AppGlobals.ASSIGNMENT_URL
        RequestManager.shared.makeRequest(url: url, method: .get) { response in
            guard let data = response.result.value else {
                print("error")
                return
            }
            
            guard let collection = JSON(data)["assignment_collection"].array else {
                completion(nil)
                return
            }
            
            var assignmentList:[Assignment] = [Assignment]()
            
            for assignment in collection {
                //Instantiate Assignment object from JSON data
                assignmentList.append(Assignment(data: assignment))
            }
            
            //Get 2-dimensional Assignment array split by Term
            guard var termSortedAssignments = Term.splitByTerms(listToSort: assignmentList) else {
                completion(nil)
                return
            }
            var sortedAssignments:[[[Assignment]]] = [[[Assignment]]]()
            let numTerms:Int = termSortedAssignments.count
            
            //For each term-specific gradeList, sort by Site and insert into 3-dim array
            for index in 0..<numTerms {
                //Sort each array by date before splitting by Site
                termSortedAssignments[index].sort{$0.getDueDate() > $1.getDueDate()}
                sortedAssignments.append(Site.splitBySites(listToSort: termSortedAssignments[index])!)
            }
            
            completion(sortedAssignments)
        }
    }
    
    /// Makes a request to retrieve all assignment data for a user and then parses them into Assignment objects. Then it splits Assignment's by Term, and then sorts each inner array by Due Date to pass [[Assignment]] object into completion handler
    ///
    /// - Parameter completion: A closure called with a 2-dimensional Assignment array to be implemented by caller
    /// - Parameter assignments: The 2-dimensional array of Assignments to be passed into the completion handler
    func getAllAssignments(completion: @escaping (_ assignments: [[Assignment]]?) -> Void) {
        let url:String = AppGlobals.ASSIGNMENT_URL
        RequestManager.shared.makeRequest(url: url, method: .get) { response in
            guard let data = response.result.value else {
                print("error")
                return
            }
            
            guard let collection = JSON(data)["assignment_collection"].array else {
                completion(nil)
                return
            }
            
            var assignmentList:[Assignment] = [Assignment]()
            
            for assignment in collection {
                //Instantiate Assignment object from JSON and add to list
                assignmentList.append(Assignment(data: assignment))
            }
            
            //Sort the list by due date before splitting by Term
            assignmentList.sort{$0.getDueDate() > $1.getDueDate()}
            guard let termSortedAssignments = Term.splitByTerms(listToSort: assignmentList) else {
                completion(nil)
                return
            }
            
            completion(termSortedAssignments)
        }
    }
    
    func getAllAnnouncements(offset:Int, limit:Int, completion: @escaping (_ announcements: [Announcement]?, _ moreLoads: Bool) -> Void) {
        let url:String = AppGlobals.ANNOUNCEMENT_URL.replacingOccurrences(of: "*", with: "\(limit)")
        RequestManager.shared.makeRequest(url: url, method: .get) { response in
            guard let data = response.result.value else {
                print("error")
                completion(nil, false)
                return
            }
            
            guard let collection = JSON(data)["announcement_collection"].array else {
                completion(nil, false)
                return
            }
            
            if offset >= collection.count {
                completion(nil, false)
                return
            }
            
            var announcementList:[Announcement] = [Announcement]()
            var start = offset
            while start < collection.count {
                let announcement = collection[start]
                announcementList.append(Announcement(data: announcement))
                start += 1
            }
            
            completion(announcementList, true)
        }
    }
    
    func getNextAssignments() {
        
    }
}
