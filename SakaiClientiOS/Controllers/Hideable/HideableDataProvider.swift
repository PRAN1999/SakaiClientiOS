//
//  HideableDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import UIKit

class HideableDataProvider<T:TermSortable> : ArrayDataProvider<T> {
    
    var terms: [Term] = []
    var isHidden: [Bool] = []
    
    override func numberOfItems(in section: Int) -> Int {
        guard section >= 0, section < isHidden.count else {
            return 0
        }
        if isHidden[section] {
            return 0
        }
        return super.numberOfItems(in: section)
    }
    
    override func resetValues() {
        terms = []
        isHidden = []
        super.resetValues()
    }
    
    override func loadItems(payload: [[T]]) {
        for index in 0..<payload.count {
            terms.append(payload[index][0].term)
            isHidden.append(true)
        }
        if isHidden.count > 0 {
            isHidden[0] = false
        }
        super.loadItems(payload: payload)
    }
    
}
