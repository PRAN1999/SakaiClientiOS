//
//  SakaiService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/2/18.
//

import Foundation

/// A singleton service to manage user data after requests have been made by serializing and sorting it
class SakaiService {

    static let shared = SakaiService()

    ///A dictionary mapping siteID's for all the user Site's to their respective Term objects.
    var siteTermMap: [String: Term] = [:]

    ///A dictionary mapping siteID's for all the user Site's to the respective Site name.
    var siteTitleMap: [String: String] = [:]

    var siteAssignmentToolMap: [String: String] = [:]

    /// An Array of Term-[SiteId] mappings that act as the source of truth for loading data by Term in a
    /// HideableNetworkSource
    var termMap: [(Term, [String])] = []

    private init() {}

    /// Reset source of truth mappings for Terms and siteId's
    func reset() {
        siteTermMap = [:]
        siteTitleMap = [:]
        siteAssignmentToolMap = [:]
        termMap = []
    }

    func validateLoggedInStatus(onSuccess: @escaping () -> Void, onFailure: @escaping (SakaiError?) -> Void) {
        let url = SakaiEndpoint.session.getEndpoint()
        RequestManager.shared.makeRequestWithoutCache(url: url, method: .get) { (data, err) in
            let decoder = JSONDecoder()
            guard let data = data else {
                onFailure(err)
                return
            }
            do {
                let _ = try decoder.decode(UserSession.self, from: data)
                onSuccess()
            } catch let decodingError {
                onFailure(SakaiError.parseError(decodingError.localizedDescription))
            }
        }
    }

    // MARK: Site Service

    /// Makes an HTTP request to determine the list of sites the user is registered for. Instantiates and
    /// sorts Sites by Term to construct 2-dimensional array of sites.
    ///
    /// Also sets AppGlobal variables to be used throughout app by mapping siteId to Term and to site title
    ///
    /// - Parameter completion: A closure called with a [[Site]] object to be implemented by callee
    /// - Parameter site: A [[Site]] object passed into closure for callee to use as needed
    func getSites(completion: @escaping (_ site: [[Site]]?, _ err: SakaiError?) -> Void) {
        let url = SakaiEndpoint.sites.getEndpoint()
        RequestManager.shared.makeRequest(url: url, method: .get) { [weak self] data, err in
            guard err == nil, let data = data else {
                completion(nil, err)
                return
            }

            let decoder = JSONDecoder()

            do {
                let siteCollectionRaw = try decoder.decode(SiteCollection.self, from: data)
                let siteList = siteCollectionRaw.siteCollection
                let _ = siteList.map {
                    self?.siteTermMap.updateValue($0.term, forKey: $0.id)
                    self?.siteTitleMap.updateValue($0.title, forKey: $0.id)
                }
                let sectionList = Term.splitByTerms(listToSort: siteList)
                // Split the site list by Term
                let listMap = sectionList.map {
                    ($0[0].term, $0.map { $0.id })
                }
                for index in 0..<listMap.count {
                    if listMap[index].0.exists() {
                        self?.termMap.append(listMap[index])
                    }
                }
                completion(sectionList, nil)
            } catch let error {
                completion(nil, SakaiError.parseError(error.localizedDescription))
            }
        }
    }

    // MARK: Grade Service

    /// An HTTP request is made to fetch all grades for all user Sites. The response is parsed into
    /// GradeItem objects and are sorted first by Term and then by Site before being passed to callback function
    ///
    /// This method is used for a user's entire gradebook history
    ///
    /// - Parameter completion: A closure called with a [[[GradeItem]]] object to be implemented by callee
    /// - Parameter grades: The [[[Gradeitem]]] object constructed with response and passed into closure
    func getAllGrades(completion: @escaping (_ grades: [[[GradeItem]]]?, SakaiError?) -> Void) {
        let url = SakaiEndpoint.gradebook.getEndpoint()
        RequestManager.shared.makeRequest(url: url, method: .get) { data, err in
            guard err == nil, let data = data else {
                completion(nil, err)
                return
            }

            let decoder = JSONDecoder()

            do {
                let gradeCollectionRaw = try decoder.decode(GradeItemCollection.self, from: data)
                let gradeList = gradeCollectionRaw.gradeItems
                //Sort gradeList by Term
                let termSortedGrades = Term.splitByTerms(listToSort: gradeList)
                var sortedGrades: [[[GradeItem]]] = [[[GradeItem]]]()
                let numTerms: Int = termSortedGrades.count
                //For each term-specific gradeList, sort by Site and insert into 3-dim array
                for index in 0..<numTerms {
                    sortedGrades.append(Site.splitBySites(listToSort: termSortedGrades[index])!)
                }
                
                completion(sortedGrades, nil)
            } catch let error {
                completion(nil, SakaiError.parseError(error.localizedDescription))
            }
        }
    }

    /// Makes request to get gradebook items for specfic site and constructs array of GradeItem to pass into callback
    ///
    /// - Parameters:
    ///   - siteId: The siteId representing the site for which grades should be fetched
    ///   - completion: A closure called with a [GradeItem] object to be implemented by callee
    ///   - grades: The [GradeItem] object constructed with response and passed to closure
    func getSiteGrades(siteId: String, completion: @escaping (_ grades: [GradeItem]?, SakaiError?) -> Void) {
        let url = SakaiEndpoint.siteGradebook(siteId).getEndpoint()
        RequestManager.shared.makeRequest(url: url, method: .get) { data, err in
            guard err == nil, let data = data else {
                completion(nil, err)
                return
            }

            let decoder = JSONDecoder()

            do {
                let siteGradeItems = try decoder.decode(SiteGradeItems.self, from: data)
                let gradeList = siteGradeItems.gradeItems
                completion(gradeList, nil)
            } catch let error {
                completion(nil, SakaiError.parseError(error.localizedDescription))
            }
        }
    }

    /// Use a dispatch group to retrieve grade data for multiple siteId's and callback once all data has been retrieved
    ///
    /// - Parameters:
    ///   - sites: The siteId's in the Term for which grade data should be retrieved
    ///   - completion: An array of GradeItem objects, split internally by Site
    func getTermGrades(for sites: [String], completion: @escaping (_ gradeItems: [[GradeItem]]?, SakaiError?) -> Void) {
        let group = DispatchGroup()
        var termGradeArray: [[GradeItem]] = []
        var errors: [SakaiError] = []
        for site in sites {
            group.enter()
            getSiteGrades(siteId: site) { res, err in
                DispatchQueue.global().async {
                    if let err = err {
                        errors.append(err)
                    }
                    if let response = res {
                        termGradeArray.append(response)
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: .main, work: .init(block: {
            var error: SakaiError? = SakaiError.dispatchGroupError(errors)
            if errors.count == 0 {
                error = nil
            }
            completion(termGradeArray, error)
        }))
    }

    // MARK: AssignmentService

    /// Makes a request to retrieve all assignment data for a user and then parses them into Assignment objects.
    /// Then it splits Assignment's by Term and Site, and then sorts each innermost array by Due Date to pass
    /// [[[Assignment]]] object into completion handler
    ///
    /// This method is used to retrive a user's Assignment history by Site
    ///
    /// - Parameter completion: A closure called with a 3-dimensional Assignment array to be implemented by caller
    /// - Parameter assignments: The 3-dimensional array of Assignments to be passed into the completion handler
    func getAllAssignments(completion: @escaping (_ assignments: [[[Assignment]]]?, SakaiError?) -> Void) {
        let url = SakaiEndpoint.assignments.getEndpoint()
        RequestManager.shared.makeRequest(url: url, method: .get) { data, err in
            guard err == nil, let data = data else {
                completion(nil, err)
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970

            do {
                let rawCollection = try decoder.decode(AssignmentCollection.self, from: data)
                let assignmentList = rawCollection.assignmentCollection
                //Get 2-dimensional Assignment array split by Term
                var termSortedAssignments = Term.splitByTerms(listToSort: assignmentList)
                var sortedAssignments: [[[Assignment]]] = [[[Assignment]]]()
                let numTerms: Int = termSortedAssignments.count
                //For each term-specific gradeList, sort by Site and insert into 3-dim array
                for index in 0..<numTerms {
                    //Sort each array by date before splitting by Site
                    termSortedAssignments[index].sort { $0.dueDate > $1.dueDate }
                    sortedAssignments.append(Site.splitBySites(listToSort: termSortedAssignments[index])!)
                }
                completion(sortedAssignments, nil)
            } catch let error {
                completion(nil, SakaiError.parseError(error.localizedDescription))
            }
        }
    }

    /// Make a request to retrieve assignment data for a site and construct Assignment array from JSON
    ///
    /// - Parameters:
    ///   - siteId: The siteId representing the site for which assignments should be fetched
    ///   - completion: The callback to be executed with an [Assignment] array
    func getSiteAssignments(for siteId: String, completion: @escaping (_ assignments: [Assignment]?, SakaiError?) -> Void) {
        let url = SakaiEndpoint.siteAssignments(siteId).getEndpoint()
        RequestManager.shared.makeRequest(url: url, method: .get) { data, err in
            guard err == nil, let data = data else {
                completion(nil, err)
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970

            do {
                let rawCollection = try decoder.decode(AssignmentCollection.self, from: data)
                var assignments = rawCollection.assignmentCollection
                assignments.sort { $0.dueDate > $1.dueDate }
                completion(assignments, nil)
            } catch let error {
                completion(nil, SakaiError.parseError(error.localizedDescription))
            }
        }
    }

    /// Use a dispatch group to retrieve assignment data for multiple siteId's and callback only once all data has been
    /// retrieved
    ///
    /// - Parameters:
    ///   - sites: The siteId's in the Term for which assignment data should be retrieved
    ///   - completion: An array of Assignment objects, split internally by Site
    func getTermAssignments(for sites: [String], completion: @escaping (_ gradeItems: [[Assignment]]?, SakaiError?) -> Void) {
        let group = DispatchGroup()
        var termAssignmentArray: [[Assignment]] = []
        var errors: [SakaiError] = []
        for site in sites {
            group.enter()
            getSiteAssignments(for: site) { res, err in
                DispatchQueue.global().async {
                    if let err = err {
                        errors.append(err)
                    }
                    if let response = res {
                        termAssignmentArray.append(response)
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: .main, work: .init(block: {
            var error: SakaiError? = SakaiError.dispatchGroupError(errors)
            if errors.count == 0 {
                error = nil
            }
            completion(termAssignmentArray, error)
        }))
    }

    // MARK: Announcement Service

    /// Requests announcement data and retrieves the Announcement feed for a user based on a specific offset and limit.
    /// Passes parsed list back into callback along with information as to whether more data exists to be loaded on the
    /// server
    ///
    /// **Example**: A request with offset 50 and limit 100 will retrieve 50 announcements from #50 to the end of the
    /// retrieved list
    ///
    /// - Parameters:
    ///   - offset: The offset position to begin parsing the retrieved list data
    ///   - limit: The limit for how many records should be retrieved from Sakai
    ///   - completion: The callback to execute with the parsed list of Announcement objects
    func getAllAnnouncements(offset: Int, limit: Int, daysBack: Int, siteId: String? = nil,
                             completion: @escaping ([Announcement]?, Bool, SakaiError?) -> Void) {
        var url = SakaiEndpoint.announcements(limit, daysBack).getEndpoint()
        if let siteId = siteId {
            url = SakaiEndpoint.siteAnnouncements(siteId, limit, daysBack).getEndpoint()
        }
        RequestManager.shared.makeRequest(url: url, method: .get) { data, err in
            guard err == nil, let data = data else {
                completion(nil, false, err)
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970

            do {
                let rawCollection = try decoder.decode(AnnouncementCollection.self, from: data)
                var collection = rawCollection.announcementCollection

                if offset >= collection.count {
                    completion(nil, false, nil)
                    return
                }

                var announcementList: [Announcement] = [Announcement]()
                var start = offset
                while start < collection.count {
                    collection[start].setAttributedContent()
                    announcementList.append(collection[start])
                    start += 1
                }
                completion(announcementList, true, nil)

            } catch let error {
                completion(nil, false, SakaiError.parseError(error.localizedDescription))
            }
        }
    }

    // MARK: Resource Service

    /// Request resource data for a siteId and construct ResourceNode tree to pass into callback
    ///
    /// - Parameters:
    ///   - siteId: The siteId for which to request Resource data
    ///   - completion: A callback to execute with a [ResourceNode] parameter
    func getSiteResources(for siteId: String, completion: @escaping ([ResourceNode]?, SakaiError?) -> Void) {
        let url = SakaiEndpoint.siteResources(siteId).getEndpoint()
        RequestManager.shared.makeRequest(url: url, method: .get) { data, err in
            guard err == nil, let data = data else {
                completion(nil, err)
                return
            }
            let decoder = JSONDecoder()
            do {
                let collection = try decoder.decode(ResourceCollection.self, from: data)
                let resourceCollection = collection.contentCollection
                let tree = ResourceNode(data: resourceCollection)
                completion(tree.children, err)
            } catch let error {
                completion(nil, SakaiError.parseError(error.localizedDescription))
            }
        }
    }

    // MARK: Chat Room Service

    func submitMessage(text: String, csrftoken: String, chatChannelId: String, completion: @escaping () -> Void) {
        let parameters = [
            "body": text,
            "chatChannelId": chatChannelId,
            "csrftoken": csrftoken
        ]
        let url = SakaiEndpoint.newChat.getEndpoint()
        RequestManager.shared.makeRequest(url: url, method: .post, parameters: parameters) { res, err in
            completion()
        }
    }
}
