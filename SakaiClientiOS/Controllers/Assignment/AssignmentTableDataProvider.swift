//
//  AssignmentTableDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/14/18.
//

import ReusableSource
import Foundation

/// The data provider for the Assignments tab tableView
class AssignmentTableDataProvider: HideableNetworkDataProvider {

    typealias T = [Assignment]
    typealias V = [[Assignment]]

    private(set) var dateSorted = false

    var terms: [Term] = []
    var isHidden: [Bool] = []
    var hasLoaded: [Bool] = []

    private var assignments: [[[Assignment]]] = []
    private var dateSortedAssignments: [[Assignment]] = []
    private var collapsedSections: [[Bool]] = []
    private var collapsedDateSections: [Bool] = []
    
    func numberOfSections() -> Int {
        return assignments.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        if dateSorted && assignments[section].count > 0 {
            return 1
        }
        return assignments[section].count
    }
    
    /// Depending on the type of sort requested, data will either be returned by
    /// class or by Term, which is achieved by adding together the data of multiple
    /// classes
    ///
    /// - Parameter indexPath: the indexPath for the cell
    /// - Returns: an Assignment array for a cell
    func item(at indexPath: IndexPath) -> [Assignment]? {
        if dateSorted {
            if dateSortedAssignments[indexPath.section].count == 0 {
                var res = assignments[indexPath.section].flatMap { $0 }
                res.sort { $0.dueDate > $1.dueDate }
                dateSortedAssignments[indexPath.section] = res
            }
            return dateSortedAssignments[indexPath.section]
        }
        return assignments[indexPath.section][indexPath.row]
    }
    
    func resetValues() {
        resetTerms()
        assignments = [[[Assignment]]].init(repeating: [[Assignment]](), count: terms.count)
        dateSortedAssignments = [[Assignment]].init(repeating: [Assignment](), count: terms.count)
        collapsedSections = [[Bool]].init(repeating: [Bool](), count: terms.count)
        collapsedDateSections = [Bool].init(repeating: false, count: terms.count)
    }
    
    func loadItems(payload: [[Assignment]], for section: Int) {
        var res = payload
        var index = 0
        while index < res.count {
            // If there are no Assignments for any single class, remove it from the data source
            if res[index].count == 0 {
                res.remove(at: index)
                index -= 1
            }
            index += 1
        }
        assignments[section] = res
        collapsedSections[section] = [Bool].init(repeating: true, count: res.count)
    }

    func isCollapsed(at indexPath: IndexPath) -> Bool {
        if isEmpty(section: indexPath.section) {
            return false
        }
        if dateSorted {
            return collapsedDateSections[indexPath.section]
        }
        return collapsedSections[indexPath.section][indexPath.row]
    }

    func toggleCollapsed(at indexPath: IndexPath) {
        if isEmpty(section: indexPath.section) {
            return
        }
        if dateSorted {
            collapsedDateSections[indexPath.section] = !collapsedDateSections[indexPath.section]
            return
        }
        collapsedSections[indexPath.section][indexPath.row] = !collapsedSections[indexPath.section][indexPath.row]
    }

    func toggleDateSorted(to newVal: Bool) {
        dateSorted = newVal
    }
}
