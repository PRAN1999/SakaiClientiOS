//
//  CacheUpdateService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/1/19.
//

import Foundation

protocol CacheUpdateService {
    func updateSiteTitle(siteId: String, title: String)
    func updateSiteTerm(siteId: String, term: Term)
    func appendTermMap(map: (Term, [String]))
}
