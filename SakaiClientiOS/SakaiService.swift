//
//  SakaiService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/2/18.
//

import Foundation
import SwiftyJSON


/// A singleton service to manage user data after requests have been made by serializing and sorting it
class SakaiService {
    
    static let shared = SakaiService()
    
    ///A dictionary mapping siteID's for all the user Site's to their respective Term objects.
    ///
    ///For use in Assignment model and GradeItem model
    var siteTermMap:[String: Term] = [:]
    
    ///A dictionary mapping siteID's for all the user Site's to the respective Site name.
    ///
    ///For use in SiteAssignmentDataSource when setting site title
    var siteTitleMap:[String:String] = [:]
    
    var termMap: [(Term, [String])] = []
    
    private init() {}
    
    func reset() {
        siteTermMap = [:]
        siteTitleMap = [:]
        termMap = []
    }
    
    /**
     
     Makes an HTTP request to determine the list of sites the user is registered for. Instantiates and sorts Sites by Term to construct 2-dimensional array of sites. That array is passed into completion handler for callee to use as needed. Also sets AppGlobal variables to be used throughout app by mapping siteId to Term and to site title
     
     - parameter completion: A closure called with a [[Site]] object to be implemented by callee
     - parameter site: A [[Site]] object passed into closure for callee to use as needed
     
     */
    func getSites(completion: @escaping (_ site: [[Site]]?) -> Void) {
        RequestManager.shared.makeRequest(url: AppGlobals.SITES_URL, method: .get) { res in
            
            guard let response = res else {
                completion(nil)
                return
            }
            //print(response)
            guard let data = response.result.value else {
                completion(nil)
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
                self.siteTermMap.updateValue(site.term, forKey: site.id)
                self.siteTitleMap.updateValue(site.title, forKey: site.id)
            }
            guard let sectionList = Term.splitByTerms(listToSort: siteList) else {
                completion(nil)
                return
            } //Split the site list by Term
            
            let listMap = sectionList.map {
                ($0[0].term, $0.map { $0.id })
            }
            
            for index in 0..<listMap.count {
                if listMap[index].0.exists() {
                    self.termMap.append(listMap[index])
                }
            }
            
            completion(sectionList)
        }
    }
    
    /**
     
     Makes HTTP request to get gradebook items for specfic site and constructs array of GradeItem to pass into closure
     
     This method is used for a Site-specific gradebook
     
     - parameters:
        - siteId: The siteId representing the site for which grades should be fetched
        - completion: A closure called with a [GradeItem] object to be implemented by callee
        - grades: The [GradeItem] object constructed with response and passed to closure
     
     */
    func getSiteGrades(siteId:String, completion: @escaping (_ grades: [GradeItem]?) -> Void) {
        let url:String = AppGlobals.SITE_GRADEBOOK_URL.replacingOccurrences(of: "*", with: siteId)
        RequestManager.shared.makeRequest(url: url, method: .get) { res in
            
            guard let response = res else {
                completion(nil)
                return
            }
            
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
    
    
    /// An HTTP request is made to fetch all grades for all user Sites. The response is parsed into GradeItem objects and are sorted first by Term and then by Site before being passed to callback function
    ///
    /// This method is used for a user's entire gradebook history
    ///
    /// - Parameter completion: A closure called with a [[[GradeItem]]] object to be implemented by callee
    /// - Parameter grades: The [[[Gradeitem]]] object constructed with response and passed into closure
    func getAllGrades(completion: @escaping (_ grades: [[[GradeItem]]]?) -> Void) {
        let url:String = AppGlobals.GRADEBOOK_URL
        RequestManager.shared.makeRequest(url: url, method: .get) { res in
            
            guard let response = res else {
                completion(nil)
                return
            }
            
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
    /// This method is used to retrive a user's Assignment history by Site
    ///
    /// - Parameter completion: A closure called with a 3-dimensional Assignment array to be implemented by caller
    /// - Parameter assignments: The 3-dimensional array of Assignments to be passed into the completion handler
    func getAllAssignmentsBySites(completion: @escaping (_ assignments: [[[Assignment]]]?) -> Void) {
        let url:String = AppGlobals.ASSIGNMENT_URL
        RequestManager.shared.makeRequest(url: url, method: .get) { res in
            
            guard let response = res else {
                completion(nil)
                return
            }
            
            guard let data = response.result.value else {
                print("error")
                completion(nil)
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
                termSortedAssignments[index].sort{$0.dueDate > $1.dueDate}
                sortedAssignments.append(Site.splitBySites(listToSort: termSortedAssignments[index])!)
            }
            
            completion(sortedAssignments)
        }
    }
    
    func getSiteAssignments(for siteId: String, completion: @escaping (_ assignments: [Assignment]?) -> Void) {
        let url:String = AppGlobals.SITE_ASSIGNMENT_URL.replacingOccurrences(of: "*", with: siteId)
        RequestManager.shared.makeRequest(url: url, method: .get) { res in
            
            guard let response = res else {
                completion(nil)
                return
            }
            
            guard let data = response.result.value else {
                print("error")
                completion(nil)
                return
            }
            
            var assignments:[Assignment] = [Assignment]()
            guard let assignmentsJSON = JSON(data)["assignment_collection"].array else { //Ensure the JSON data has an "assignments" array
                completion(nil)
                return
            }
            
            for assignmentJSON in assignmentsJSON {
                //Construct a GradeItem object and add it to the gradeList
                assignments.append(Assignment(data: assignmentJSON))
            }
            
            assignments.sort { $0.dueDate > $1.dueDate }
            
            completion(assignments)
        }
    }
    
    
    /// Requests announcement data and retrieves the Announcement feed for a user based on a specific offset and limit. Passes parsed list back into callback along with information as to whether more data exists to be loaded on the server
    ///
    /// **Example**: A request with offset 50 and limit 100 will retrieve 50 announcements from #50 to the end of the retrieved list
    ///
    /// - Parameters:
    ///   - offset: The offset position to begin parsing the retrieved list data
    ///   - limit: The limit for how many records should be retrieved from Sakai
    ///   - completion: The callback to execute with the parsed list of Announcement objects
    func getAllAnnouncements(offset:Int, limit:Int, completion: @escaping (_ announcements: [Announcement]?, _ moreLoads: Bool) -> Void, siteId: String? = nil) {
        var url: String
        if let id = siteId {
            url = AppGlobals.SITE_ANNOUNCEMENTS_URL.replacingOccurrences(of: "*", with: id).replacingOccurrences(of: "#", with: "\(limit)")
        } else {
            url = AppGlobals.ANNOUNCEMENT_URL.replacingOccurrences(of: "*", with: "\(limit)")
        }
        RequestManager.shared.makeRequest(url: url, method: .get) { res in
            
            guard let response = res else {
                completion(nil, false)
                return
            }
            
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
    
    func getTermGrades(for sites: [String], completion: @escaping (_ gradeItems: [[GradeItem]]?) -> Void) {
        let group = DispatchGroup()
        var termGradeArray: [[GradeItem]] = []
        
        for site in sites {
            group.enter()
            getSiteGrades(siteId: site) { (res) in
                DispatchQueue.global().async {
                    if let response = res {
                        termGradeArray.append(response)
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main, work: .init(block: {
            completion(termGradeArray)
        }))
        
    }
    
    func getTermAssignments(for sites: [String], completion: @escaping (_ gradeItems: [[Assignment]]?) -> Void) {
        let group = DispatchGroup()
        var termAssignmentArray: [[Assignment]] = []
        
        for site in sites {
            group.enter()
            getSiteAssignments(for: site) { (res) in
                DispatchQueue.global().async {
                    if let response = res {
                        termAssignmentArray.append(response)
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main, work: .init(block: {
            completion(termAssignmentArray)
        }))
        
    }
}
