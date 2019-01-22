//
//  SiteDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/12/18.
//

import Foundation
import ReusableSource

/// Manage Site information according to Term
class SiteDataProvider : HideableDataProvider {
    
    typealias T = Site
    typealias V = [[Site]]
    
    var terms: [Term] = []
    var isHidden: [Bool] = []
    
    private var sites: [[Site]] = []

    /// Used so search will have data source to filter on
    private lazy var filteredSites = sites
    
    func numberOfSections() -> Int {
        return filteredSites.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        return filteredSites[section].count
    }
    
    func item(at indexPath: IndexPath) -> Site? {
        return filteredSites[indexPath.section][indexPath.row]
    }
    
    func resetValues() {
        resetTerms()
        sites = []
        filteredSites = []
    }
    
    func loadItems(payload: [[Site]]) {
        // The payload is assumed to be a Term-split 2D-array of Sites.
        if payload.count == 0 {
            return
        }
        
        for index in 0..<payload.count {
            if payload[index].count < 1 {
                continue
            }
            terms.append(payload[index][0].term)
            isHidden.append(true)
        }
        // By default show the classes in the most recent Term
        isHidden[0] = false
        sites = payload
        filteredSites = sites
    }
}
