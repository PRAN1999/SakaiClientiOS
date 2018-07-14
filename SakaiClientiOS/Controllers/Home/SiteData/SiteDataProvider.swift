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
    
    var sites: [[Site]] = []
    
    // MARK: - DataProvider
    func numberOfSections() -> Int {
        return sites.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard section >= 0 && section < sites.count else {
            return 0
        }
        return sites[section].count
    }
    
    func item(at indexPath: IndexPath) -> Site? {
        guard indexPath.section >= 0 && indexPath.section < sites.count &&
            indexPath.row >= 0 && indexPath.row < sites[indexPath.section].count else {
                return nil
        }
        return sites[indexPath.section][indexPath.row]
    }
    
    func resetValues() {
        resetTerms()
        sites = []
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
    }
    
}
