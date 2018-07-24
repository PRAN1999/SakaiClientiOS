//
//  AssignmentDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/14/18.
//

import ReusableSource
import Foundation

class AssignmentTableDataProvider: HideableDataProvider {
    
    typealias T = [Assignment]
    typealias V = [[[Assignment]]]
    
    var terms: [Term] = []
    var isHidden: [Bool] = []
    var hasLoaded: [Bool] = []
    
    var assignments: [[[Assignment]]] = []
    
    var dateSortedAssignments: [Assignment]?
    var dateSorted = false
    
    func numberOfSections() -> Int {
        return assignments.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        if dateSorted {
            return 1
        }
        return assignments[section].count
    }
    
    func item(at indexPath: IndexPath) -> [Assignment]? {
        if dateSorted {
            if dateSortedAssignments == nil {
                var res: [Assignment] = []
                let assignmentList = assignments[indexPath.section]
                let count = assignmentList.count
                for index in 0..<count {
                    res.append(contentsOf: assignmentList[index])
                }
                res.sort { $0.dueDate > $1.dueDate }
                dateSortedAssignments = res
            }
            
            return dateSortedAssignments
        }
        return assignments[indexPath.section][indexPath.row]
    }
    
    func resetValues() {
        resetTerms()
        assignments = []
    }
    
    func loadItems(payload: [[[Assignment]]]) {
        if payload.count == 0 {
            return
        }
        
        for index in 0..<payload.count {
            terms.append(payload[index][0][0].term)
            isHidden.append(true)
        }
        isHidden[0] = false
        
        assignments = payload
    }
}
