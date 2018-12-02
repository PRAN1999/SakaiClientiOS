//
//  SiteDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/12/18.
//

import Foundation
import ReusableSource

class SiteDataProvider : HideableDataProvider {
    
    typealias T = Site
    typealias V = [[Site]]
    
    var terms: [Term] = []
    var isHidden: [Bool] = []
    
    private var sites: [[Site]] = []
    private lazy var filteredSites = sites
    
    // MARK: - DataProvider
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
        if payload.count == 0 {
            return
        }
        
        for index in 0..<payload.count {
            terms.append(payload[index][0].term)
            isHidden.append(true)
        }
        isHidden[0] = false
        sites = payload
        filteredSites = sites
    }

    func toggleHidden(for section: Int, to newVal: Bool) {
        guard section >= 0 && section < terms.count else {
            return
        }
        isHidden[section] = newVal
    }
}
