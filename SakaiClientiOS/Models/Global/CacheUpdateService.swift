//
//  CacheUpdateService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/1/19.
//

import Foundation


/// A service that allows updating the global app cache for Site information
protocol CacheUpdateService {
    func updateSiteTitle(siteId: String, title: String)
    func updateSiteTerm(siteId: String, term: Term)
    func updateSiteSubjectCode(siteId: String, subjectCode: Int)
    func appendTermMap(map: (Term, [String]))
}
