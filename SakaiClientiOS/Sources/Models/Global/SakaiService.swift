//
//  SakaiService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/2/18.
//

import Foundation

/// The source of truth for the app
///
/// Sakai's API's do not relate Gradebook, Announcement, and Assignment
/// information in a way that links them to a specific Term and it provides
/// no information about the containing site beyond a siteId. Therefore,
/// a source of truth must be maintained in the app so that all data can
/// be constructed and related in the same manner.
///
/// The source of truth includes:
///     siteTermMap: Map each siteId to it's containing Term
///     siteTitleMap: Map each siteId to the name of the associated Site
///     siteAssignmentToolMap: Map each siteId to a specific URL used to
///                            construct a reference to each Assignment page
///     siteSubjectCode: Map each siteId to its subject code
///     termMap: A global array of Terms mapped to all sites within the Term
class SakaiService {

    static let shared = SakaiService()

    private(set) var siteTermMap: [String: Term] = [:]
    private(set) var siteTitleMap: [String: String] = [:]
    private(set) var siteAssignmentToolMap: [String: String] = [:]
    private(set) var siteSubjectCode: [String: Int] = [:]
    private(set) var termMap: [(Term, [String])] = []

    private init() {}

    func reset() {
        siteTermMap = [:]
        siteTitleMap = [:]
        siteAssignmentToolMap = [:]
        siteSubjectCode = [:]
        termMap = []
    }
}

extension SakaiService: TermService {}

extension SakaiService: CacheUpdateService {
    func updateSiteTitle(siteId: String, title: String) {
        siteTitleMap.updateValue(title, forKey: siteId)
    }

    func updateSiteTerm(siteId: String, term: Term) {
        siteTermMap.updateValue(term, forKey: siteId)
    }

    func updateSiteSubjectCode(siteId: String, subjectCode: Int) {
        siteSubjectCode.updateValue(subjectCode, forKey: siteId)
    }

    func appendTermMap(map: (Term, [String])) {
        termMap.append(map)
    }

    func setAssignmentToolUrl(url: String, siteId: String) {
        siteAssignmentToolMap.updateValue(url, forKey: siteId)
    }
}
