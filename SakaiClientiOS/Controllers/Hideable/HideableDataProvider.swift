//
//  HideableDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import UIKit
import ReusableSource

protocol HideableDataProvider: class, DataProvider {
    var terms: [Term] { get set }
    var isHidden: [Bool] { get set }
}

extension HideableDataProvider {
    
    func numberOfItemsForHideableSection(section: Int) -> Int {
        guard section >= 0, section < isHidden.count else {
            return 0
        }
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
