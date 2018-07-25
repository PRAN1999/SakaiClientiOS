//
//  HideableNetworkDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/23/18.
//

import ReusableSource

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
    
    func resetTerms() {
        terms = DataHandler.shared.termMap.map { $0.0 }
        isHidden = [Bool].init(repeating: true, count: terms.count)
        hasLoaded = [Bool].init(repeating: false, count: terms.count)
    }
    
    func loadItems(payload: V) {
        loadItems(payload: payload, for: 0)
    }
}
