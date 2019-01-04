//
//  SakaiService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/2/18.
//

import Foundation

class SakaiService {

    static let shared = SakaiService()

    // MARK: Source of Truth

    private(set) var siteTermMap: [String: Term] = [:]
    private(set) var siteTitleMap: [String: String] = [:]
    private(set) var siteAssignmentToolMap: [String: String] = [:]
    private(set) var siteSubjectCode: [String: Int] = [:]
    private(set) var termMap: [(Term, [String])] = []

    private init() {}

    /// Reset source of truth
    func reset() {
        siteTermMap = [:]
        siteTitleMap = [:]
        siteAssignmentToolMap = [:]
        siteSubjectCode = [:]
        termMap = []
    }

    func setAssignmentToolUrl(url: String, siteId: String) {
        siteAssignmentToolMap.updateValue(url, forKey: siteId)
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
}
