//
//  GradebookDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/12/18.
//

import UIKit
import ReusableSource

/// The data source for the Gradebook tab tableView. Manages gradebook data and
/// provides it to the tableView split by both Term and class.
///
/// Since a tableView only has one layer of section headings, custom tableView cells
/// are used as nested section headers and the GradebookDataProvider provides that
/// data in the appropriate format
class GradebookDataProvider: HideableNetworkDataProvider {
    
    var terms: [Term] = []
    var isHidden: [Bool] = []
    var gradeItems: [[[GradeItem]]] = []
    var hasLoaded: [Bool] = []
    
    typealias T = GradeItem
    typealias V = [[GradeItem]]
    
    func numberOfSections() -> Int {
        return gradeItems.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        var numRows = gradeItems[section].count
        for j in 0..<gradeItems[section].count {
            numRows += gradeItems[section][j].count
        }
        return numRows
    }
    
    /// If an indexPath represents a nested section header, return nil. Otherwise
    /// return the corresponding GradeItem according to the indexPath and the subsection
    /// indexPath
    ///
    /// - Parameter indexPath: the indexPath in the tableView for this cell
    /// - Returns: If the cell is not a section header, return a GradeItem, otherwise nil
    func item(at indexPath: IndexPath) -> GradeItem? {
        let subsection = getSubsectionIndexPath(section: indexPath.section, row: indexPath.row)

        // If the subsection is 0, the indexPath of the tableView represents a nested section header
        guard subsection.row != 0 else {
            print("subsection is 0")
            return nil
        }
        
        let item = gradeItems[indexPath.section][subsection.section][subsection.row - 1]
        return item
    }
    
    func resetValues() {
        resetTerms()
        gradeItems = [[[GradeItem]]].init(repeating: [[GradeItem]](), count: terms.count)
    }
    
    func loadItems(payload: [[GradeItem]], for section: Int) {
        var res = payload
        var index = 0
        while index < res.count {
            // Remove any empty Arrays from the data source
            if res[index].count == 0 {
                res.remove(at: index)
                index -= 1
            }
            index += 1
        }
        gradeItems[section] = res
    }
    
    /// For a given section within a UITableView and a given subsection location, retrieve
    /// the location of the associated subsection header cell
    ///
    /// - Parameters:
    ///   - section: the UITableView section
    ///   - indexPath: the subsection indexPath for a section
    /// - Returns: the row index (within the section) of the associated subsection header
    func getHeaderRowForSubsection(section: Int, indexPath: IndexPath) -> Int {
        var row = 0
        
        for index in 0..<indexPath.section {
            row += gradeItems[section][index].count + 1
        }
        
        return row
    }
    
    /// Convert a standard UITableView index path into an indexPath for a class's subsection
    /// location
    ///
    /// - Parameters:
    ///   - section: the standard UITableView section
    ///   - row: the standard UITableView row for the cell
    /// - Returns: the converted subsection IndexPath within the given section
    func getSubsectionIndexPath(section: Int, row: Int) -> IndexPath {
        let termSection: [[GradeItem]] = gradeItems[section]
        
        var startRow = row
        var subsection = 0
        while startRow > 0 {
            //print("Section: \(section) Subsection: \(subsection) StartRow: \(startRow)")
            startRow -= (termSection[subsection].count + 1)
            if(startRow >= 0) {
                subsection += 1
            }
        }
        let subRow = 0 - startRow
        return IndexPath(row: subRow, section: subsection)
    }
    
    /// Given a section and a subsection, get the title of the class represented by the
    /// subsection
    ///
    /// - Parameters:
    ///   - section: the UITableView section
    ///   - subsection: the subsection within the section
    /// - Returns: the title of a class or site represented by the subsection
    func getSubsectionTitle(section: Int, subsection: Int) -> String? {
        let siteId = gradeItems[section][subsection][0].siteId
        let title = SakaiService.shared.siteTitleMap[siteId]
        return title
    }
}
