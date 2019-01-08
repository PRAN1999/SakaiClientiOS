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
///
/// A HideableNetworkDataProvider assumes the global Term map is available
/// and requires access to a TermService in order to correctly manage Term
/// sections
protocol HideableNetworkDataProvider: HideableDataProvider {
    
    var hasLoaded: [Bool] { get set }
    
    /// Allows access to global Term map so data can be requested by Term
    var termService: TermService { get }
    
    /// Load data into the data source for the specified section
    ///
    /// Use this method after retrieving data with a DataFetcher to load
    /// data into the data source
    ///
    /// - Parameters:
    ///   - payload: the fetched data
    ///   - section: the section to load
    func loadItems(payload: V, for section: Int)

    func hasLoaded(section: Int) -> Bool
    func toggleLoaded(for section: Int, to newVal: Bool)
}

extension HideableNetworkDataProvider {

    /// Helper method to be used by numberOfRows method impl.
    func numberOfItemsForHideableNetworkSection(section: Int) -> Int {
        if !hasLoaded(section: section) {
            return 0
        }
        return numberOfItemsForHideableSection(section: section)
    }
    
    func loadItems(payload: V) {
        loadItems(payload: payload, for: 0)
    }

    func resetTerms() {
        terms = termService.termMap.map { $0.0 }
        isHidden = [Bool].init(repeating: true, count: terms.count)
        hasLoaded = [Bool].init(repeating: false, count: terms.count)
    }

    func hasLoaded(section: Int) -> Bool {
        guard section >= 0 && section < terms.count else {
            return true
        }
        return hasLoaded[section]
    }

    func toggleLoaded(for section: Int, to newVal: Bool) {
        guard section >= 0 && section < terms.count else {
            return
        }
        hasLoaded[section] = newVal
    }
}
