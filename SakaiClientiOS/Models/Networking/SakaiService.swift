//
//  SakaiService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/2/18.
//

import Foundation

/// A singleton service to request user data and de-serialize and sort it into the appropriate data structure
class SakaiService {

    static let shared = SakaiService()

    // MARK: Source of Truth

    var siteTermMap: [String: Term] = [:]
    var siteTitleMap: [String: String] = [:]
    var siteAssignmentToolMap: [String: String] = [:]
    var termMap: [(Term, [String])] = []

    var allAnnouncements: [Announcement]?
    var siteAnnouncements: [String: [Announcement]] = [:]

    let announcementLimit = 100000

    private init() {
    }

    /// Reset source of truth mappings for Terms and siteId's
    func reset() {
        siteTermMap = [:]
        siteTitleMap = [:]
        siteAssignmentToolMap = [:]
        termMap = []
        allAnnouncements = nil
        siteAnnouncements = [:]
    }

    // MARK: Authentication Validator

    func validateLoggedInStatus(onSuccess: @escaping () -> Void, onFailure: @escaping (SakaiError?) -> Void) {
        let url = SakaiEndpoint.session.getEndpoint()
        RequestManager.shared.makeRequestWithoutCache(url: url, method: .get) { (data, err) in
            let decoder = JSONDecoder()
            guard let data = data else {
                onFailure(err)
                return
            }
            do {
                let session = try decoder.decode(UserSession.self, from: data)
                RequestManager.shared.userId = session.userEid
                onSuccess()
            } catch let decodingError {
                onFailure(SakaiError.parseError(decodingError.localizedDescription))
            }
        }
    }

    // MARK: Site Service

    /// Request user Site data and split by Term. Updates source of truth mappings for SiteTermMap and SiteTitleMap
    /// with newly requested data.
    ///
    /// Until this request successfully calls back with the requested, no other requests can be executed.
    ///
    /// - Parameter completion: a completion handler called with a [[Site]] split by Term and an optional SakaiError
    func getSites(completion: @escaping ([[Site]]?, SakaiError?) -> Void) {
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

    /// Request the user's entire gradebook history and de-serialize into a list of GradeItems. Then splits list by Term
    /// and by Site.
    ///
    /// - Parameter completion: a completion handler called with a [[[GradeItem]]] and an optional SakaiError
    func getAllGrades(completion: @escaping ([[[GradeItem]]]?, SakaiError?) -> Void) {
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

    /// Request gradebook data for a specific Site and de-serialize into a list of GradeItem
    ///
    /// - Parameters:
    ///   - siteId: the identifier for the requested Site
    ///   - completion: a completion handler called with a [GradeItem] and an optional SakaiError
    func getSiteGrades(siteId: String, completion: @escaping ([GradeItem]?, SakaiError?) -> Void) {
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

    /// Use a dispatch group to retrieve grade data for multiple Sites and callback once all data has been retrieved
    ///
    /// - Parameters:
    ///   - sites: the identifiers for the requested Sites
    ///   - completion: a completion handler called with a [[GradeItem]] and an optional SakaiError.
    ///
    ///     It is possible that parsed data and error may be both non-nil if one request failed and others succeeded
    func getTermGrades(for sites: [String], completion: @escaping ([[GradeItem]]?, SakaiError?) -> Void) {
        let group = DispatchGroup()
        var termGradeArray: [[GradeItem]] = []
        var errors: [SakaiError] = []
        for site in sites {
            group.enter()
            getSiteGrades(siteId: site) { res, err in
                DispatchQueue.global().async {
                    if let err = err {
                        switch err {
                        case .networkError( _, let code):
                            if code == 400 { break }
                        default:
                            errors.append(err)
                        }
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

    /// Request all of user's assignment data and de-serialize into a list of Assignment. Split list by
    /// Term and Site and sort each inner list by due date.
    ///
    /// - Parameter completion: a completion handler called with a [[[Assignment]]] and an optional SakaiError
    func getAllAssignments(completion: @escaping ([[[Assignment]]]?, SakaiError?) -> Void) {
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

    /// Request assignment data for a specific Site and de-serialize into a list of Assignment
    ///
    /// - Parameters:
    ///   - siteId: the identifier for the requested Site
    ///   - completion: a completion handler called with a list of Assignments and an optional SakaiError
    func getSiteAssignments(for siteId: String, completion: @escaping ([Assignment]?, SakaiError?) -> Void) {
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

    /// Use a dispatch group to retrieve assignment data for multiple Sites and callback only once all data has been
    /// retrieved
    ///
    /// - Parameters:
    ///   - sites: the identifiers for the requested Sites
    ///   - completion: a completion handler called with a [[Assignment]] and an optional SakaiError
    ///
    ///     It is possible that parsed data and error may be both non-nil if one request failed and others succeeded
    func getTermAssignments(for sites: [String], completion: @escaping ([[Assignment]]?, SakaiError?) -> Void) {
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


    /// Requests announcement data and retrieves the Announcement feed for a user based on a specific
    /// offset and limit and determines if there is more data to load from server.
    ///
    /// **Example**:
    ///
    /// A request with offset=100 and limit=150 will retrieve **50** announcements from announcement
    /// #100 to the end of the retrieved list
    ///
    /// - Parameters:
    ///   - offset: the number of Announcement objects to skip
    ///   - limit: a limit on the max number of Announcements to retrieve
    ///   - siteId: an optional identifier for a requested Site. If nil, the user's entire
    ///     Announcement history will be parsed
    ///   - completion: the completion handler called with a list of Announcements, a flag indicating
    ///     if there is more data and an optional SakaiError
    func getAllAnnouncements(offset: Int, limit: Int, siteId: String? = nil,
                             completion: @escaping ([Announcement]?, Bool, SakaiError?) -> Void) {
        var list: [Announcement]? = nil
        var url = SakaiEndpoint.announcements(announcementLimit, announcementLimit).getEndpoint()
        if let siteId = siteId {
            url = SakaiEndpoint.siteAnnouncements(siteId, announcementLimit, announcementLimit).getEndpoint()
            list = siteAnnouncements[siteId]
        } else {
            list = allAnnouncements
        }
        if let list = list {
            DispatchQueue.global(qos: .background).async { [weak self] in
                let announcementList = self?.retrieveAnnouncementSection(list: list, offset: offset, limit: limit)
                if announcementList == nil {
                    completion(nil, false, nil)
                } else {
                    completion(announcementList, true, nil)
                }
            }
            return
        }

        RequestManager.shared.makeRequest(url: url, method: .get) { [weak self] data, err in
            guard err == nil, let data = data else {
                completion(nil, false, err)
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970

            do {
                let rawCollection = try decoder.decode(AnnouncementCollection.self, from: data)
                let collection = rawCollection.announcementCollection
                if siteId != nil {
                    self?.siteAnnouncements[siteId!] = rawCollection.announcementCollection
                } else {
                    self?.allAnnouncements = rawCollection.announcementCollection
                }

                let announcementList = self?.retrieveAnnouncementSection(list: collection, offset: offset, limit: limit)

                if announcementList == nil {
                    completion(nil, false, nil)
                } else {
                    completion(announcementList, true, nil)
                }
            } catch let error {
                completion(nil, false, SakaiError.parseError(error.localizedDescription))
            }
        }
    }

    private func retrieveAnnouncementSection(list: [Announcement], offset: Int, limit: Int) -> [Announcement]? {
        if offset >= list.count {
            return nil
        }
        var announcements = list
        var announcementList: [Announcement] = []
        var start = offset
        var count = 0
        while count < limit && start < announcements.count {
            announcements[start].setAttributedContent()
            announcementList.append(announcements[start])
            start += 1
            count += 1
        }
        return announcementList
    }

    // MARK: Resource Service

    /// Request resource data for a specific Site and construct ResourceNode tree from parsed data
    ///
    /// - Parameters:
    ///   - siteId: the siteId for which to request Resource data
    ///   - completion: a completion handler to call with a [ResourceNode] representing the top children
    ///     in the resource tree, and an optional SakaiError
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

    /// Make a POST request to add a chat message to a specific chat
    ///
    /// - Parameters:
    ///   - text: the body of the chat message to send
    ///   - csrftoken: the csrftoken used to authenticate the client (retrieved from webView)
    ///   - chatChannelId: a channel id specifying which chat group to update
    ///   - completion: a completion handler called with an optional SakaiError
    func submitMessage(text: String, csrftoken: String, chatChannelId: String, completion: @escaping (SakaiError?) -> Void) {
        let parameters = [
            "body": text,
            "chatChannelId": chatChannelId,
            "csrftoken": csrftoken
        ]
        let url = SakaiEndpoint.newChat.getEndpoint()
        RequestManager.shared.makeRequest(url: url, method: .post, parameters: parameters) { res, err in
            completion(err)
        }
    }
}
