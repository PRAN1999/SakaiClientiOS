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

    var siteTermMap: [String: Term] = [:]
    var siteTitleMap: [String: String] = [:]
    var siteAssignmentToolMap: [String: String] = [:]
    var termMap: [(Term, [String])] = []

    private init() {}

    /// Reset source of truth
    func reset() {
        siteTermMap = [:]
        siteTitleMap = [:]
        siteAssignmentToolMap = [:]
        termMap = []
    }
}

extension SakaiService: TermService, CacheUpdateService {}
