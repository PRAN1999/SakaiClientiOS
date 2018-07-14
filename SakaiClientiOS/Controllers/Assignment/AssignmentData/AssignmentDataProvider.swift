//
//  AssignmentDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/14/18.
//

import ReusableSource
import Foundation

class AssignmentDataProvider: HideableDataProvider {
    var terms: [Term] = []
    var isHidden: [Bool] = []
    
    typealias T = [Assignment]
    typealias V = [[[Assignment]]]
    
    func numberOfSections() -> Int {
        return 0
    }
    
    func numberOfItems(in section: Int) -> Int {
        return 0
    }
    
    func item(at indexPath: IndexPath) -> [Assignment]? {
        return nil
    }
    
    func resetValues() {
        return
    }
    
    func loadItems(payload: [[[Assignment]]]) {
        return
    }
}
