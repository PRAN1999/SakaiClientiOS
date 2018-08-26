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
    
    func isEmpty(section: Int) -> Bool
}

extension HideableDataProvider {
    
    func isEmpty(section: Int) -> Bool {
        return numberOfItems(in: section) == 0
    }
    
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
