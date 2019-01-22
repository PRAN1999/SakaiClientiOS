//
//  MockCacheUpdateService.swift
//  SakaiClientiOSTests
//
//  Created by Pranay Neelagiri on 1/20/19.
//

import Foundation
import XCTest
@testable import SakaiClientiOS

class MockCacheUpdateService: CacheUpdateService {

    private(set) var siteTermMap: [String: Term] = [:]
    private(set) var siteTitleMap: [String: String] = [:]
    private(set) var siteAssignmentToolMap: [String: String] = [:]
    private(set) var siteSubjectCode: [String: Int] = [:]
    private(set) var termMap: [(Term, [String])] = []

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
