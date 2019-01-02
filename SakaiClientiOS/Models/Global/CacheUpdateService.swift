//
//  CacheUpdateService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/1/19.
//

import Foundation

protocol CacheUpdateService {
    var siteTermMap: [String: Term] { get set }
    var siteTitleMap: [String: String] { get set }
    var termMap: [(Term, [String])] { get set }
}
