//
//  HideableDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import ReusableSource

protocol HideableDataProvider: class, DataProvider {
    var terms: [Term] { get set }
    var isHidden: [Bool] { get set }
    
    func resetTerms()
}

extension HideableDataProvider {
    
    func numberOfItemsForHideableSection(section: Int) -> Int {
        if isHidden[section] {
            return 0
        }
        return numberOfItems(in: section)
    }
    
    func resetTerms() {
        terms = []
        isHidden = []
    }
}
