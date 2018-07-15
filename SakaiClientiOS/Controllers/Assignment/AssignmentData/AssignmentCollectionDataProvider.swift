//
//  AssignmentDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import ReusableSource

class AssignmentCollectionDataProvider: DataProvider {
    
    typealias T = Assignment
    typealias V = [Assignment]
    
    var assignments : [Assignment] = []
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return assignments.count
    }
    
    func item(at indexPath: IndexPath) -> Assignment? {
        return assignments[indexPath.row]
    }
    
    func resetValues() {
        assignments = []
    }
    
    func loadItems(payload: [Assignment]) {
        assignments = payload
    }
}
