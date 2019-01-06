//
//  GradebookDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/12/18.
//

import UIKit
import ReusableSource

/// The data source for the Gradebook tab tableView. Manages gradebook data
/// and provides it to the tableView split by both Term and class.
///
/// Since Terms contain Sites which contain GradeItems, the data structure
/// for the gradeItems is a 3D array to model both sections and subsections
class GradebookDataProvider: HideableNetworkDataProvider {
    typealias T = GradeItem
    typealias V = [[GradeItem]]
    
    var terms: [Term] = []
    var isHidden: [Bool] = []
    var hasLoaded: [Bool] = []

    let termService: TermService
    
    private var gradeItems: [[[GradeItem]]] = []
    private var isCollapsed: [[Bool]] = []

    init(termService: TermService) {
        self.termService = termService
    }
    
    func numberOfSections() -> Int {
        return gradeItems.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        return getCount(for: section)
    }
    
    /// If an indexPath represents a nested section header, return nil.
    /// Otherwise return the corresponding GradeItem according to the
    /// indexPath and the subsection indexPath
    ///
    /// - Parameter indexPath: the indexPath in the tableView for this cell
    /// - Returns: If the cell is not a section header, return a GradeItem,
    ///            otherwise nil
    func item(at indexPath: IndexPath) -> GradeItem? {
        let subsection = getSubsectionIndexPath(section: indexPath.section, row: indexPath.row)

        // If the subsection is 0, the indexPath of the tableView represents
        // a subsection header
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
        isCollapsed = [[Bool]].init(repeating: [Bool](), count: terms.count)
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
        isCollapsed[section] = [Bool].init(repeating: false, count: gradeItems[section].count)
    }
    
    /// For a given section within a UITableView and a given subsection
    /// location, retrieve the location of the associated subsection header
    /// cell
    ///
    /// - Parameters:
    ///   - section: the UITableView section
    ///   - subsection: the subsection of the Site
    ///   - indexPath: the subsection indexPath for a section
    /// - Returns: the row index (within the section) of the associated
    ///            subsection header
    func getHeaderRowForSubsection(section: Int, subsection: Int) -> Int {
        var row = 0
        
        for index in 0..<subsection {
            if isCollapsed(section: section, subsection: index) {
                row += 1
            } else {
                row += gradeItems[section][index].count + 1
            }
        }
        
        return row
    }
    
    /// Convert a standard UITableView index path into an indexPath for a
    /// class's subsection location
    ///
    /// - Parameters:
    ///   - section: the standard UITableView section
    ///   - row: the standard UITableView row for the cell
    /// - Returns: the converted subsection IndexPath within the section
    func getSubsectionIndexPath(section: Int, row: Int) -> IndexPath {
        let termSection: [[GradeItem]] = gradeItems[section]
        var startRow = row
        var subsection = 0
        while startRow > 0 {
            var classCount = termSection[subsection].count + 1
            if isCollapsed(section: section, subsection: subsection) {
                classCount = 1
            }
            startRow -= classCount
            if(startRow >= 0) {
                subsection += 1
            }
        }
        var subRow = startRow
        if subRow != 0 {
            subRow = termSection[subsection].count + 1 - -1 * startRow
        }
        return IndexPath(row: subRow, section: subsection)
    }

    func getSubsectionTitle(section: Int, subsection: Int) -> String? {
        let title = gradeItems[section][subsection][0].siteTitle
        return title
    }

    func getSubjectCode(section: Int, subsection: Int) -> Int? {
        let code = gradeItems[section][subsection][0].subjectCode
        return code
    }

    func getCount(for section: Int) -> Int {
        let count = gradeItems[section].count
        var total = 0
        for i in 0..<count {
            if isCollapsed(section: section, subsection: i) {
                total += 1
            } else {
                total += gradeItems[section][i].count + 1
            }
        }
        return total
    }

    func isCollapsed(section: Int, subsection: Int) -> Bool {
        guard section < terms.count && subsection < isCollapsed[section].count else {
            return false
        }
        return isCollapsed[section][subsection]
    }

    func toggleCollapsed(section: Int, subsection: Int) {
        guard section < terms.count && subsection < isCollapsed[section].count else {
            return
        }
        isCollapsed[section][subsection] = !isCollapsed[section][subsection]
    }

    func indexPaths(section: Int, subsection: Int) -> [IndexPath] {
        let getIndexPath: (Int) -> IndexPath = { row in
            return IndexPath(row: row, section: section)
        }
        var arr: [IndexPath] = []
        let row = getHeaderRowForSubsection(section: section, subsection: subsection)
        let totalRows = gradeItems[section][subsection].count
        for i in 0..<totalRows {
            let gradeRow = row + i + 1
            arr.append(getIndexPath(gradeRow))
        }
        return arr
    }
}
