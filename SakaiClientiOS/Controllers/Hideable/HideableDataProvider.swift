//
//  HideableDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import ReusableSource

/// A DataProvider to populate and manage data for a HideableTableManager.
/// In other words, it can show and hide data as needed for specific sections
protocol HideableDataProvider: class, DataProvider {
    var terms: [Term] { get set }
    var isHidden: [Bool] { get set }
    
    func resetTerms()
    
    func isEmpty(section: Int) -> Bool
}

extension HideableDataProvider {
    
    func isEmpty(section: Int) -> Bool {
        return numberOfItems(in: section) == 0
    }
    
    /// Helper method to determine how many rows to display based on
    /// whether section is hidden or not
    ///
    /// - Parameter section: the section for which rows will be displayed
    /// - Returns: the number of rows to be shown
    func numberOfItemsForHideableSection(section: Int) -> Int {
        if isHidden[section] {
            return 0
        }
        if isEmpty(section: section) {
            return 1
        }
        return numberOfItems(in: section)
    }
    
    func resetTerms() {
        terms = []
        isHidden = []
    }
}
