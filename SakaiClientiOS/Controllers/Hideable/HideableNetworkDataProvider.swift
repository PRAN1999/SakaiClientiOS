//
//  HideableNetworkDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/23/18.
//

import ReusableSource

/// A DataProvider to be used in conjunction with a HideableNetworkSource
/// that provides information on which sections have loaded and the ability
/// to load data into a specific section
protocol HideableNetworkDataProvider: HideableDataProvider {
    var hasLoaded: [Bool] { get set }
    
    func loadItems(payload: V, for section: Int)
}

extension HideableNetworkDataProvider {
    
    func numberOfItemsForHideableNetworkSection(section: Int) -> Int {
        if section < hasLoaded.count && !hasLoaded[section] {
            return 0
        }
        return numberOfItemsForHideableSection(section: section)
    }
    
    /// Use the "source of truth" to define how many Terms exist
    func resetTerms() {
        terms = SakaiService.shared.termMap.map { $0.0 }
        isHidden = [Bool].init(repeating: true, count: terms.count)
        hasLoaded = [Bool].init(repeating: false, count: terms.count)
    }
    
    func loadItems(payload: V) {
        loadItems(payload: payload, for: 0)
    }
}
