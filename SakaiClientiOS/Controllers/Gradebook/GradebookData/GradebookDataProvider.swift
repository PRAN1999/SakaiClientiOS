//
//  GradebookDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/12/18.
//

import UIKit
import ReusableSource

class GradebookDataProvider: HideableDataProvider {
    
    var terms: [Term] = []
    var isHidden: [Bool] = []
    var gradeItems:[[[GradeItem]]] = []
    
    typealias T = GradeItem
    typealias V = [[[GradeItem]]]
    
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
    
    func item(at indexPath: IndexPath) -> GradeItem? {
        let subsection = getSubsectionIndexPath(section: indexPath.section, row: indexPath.row)
        
        guard subsection.row != 0 else {
            return nil
        }
        
        let item = gradeItems[indexPath.section][subsection.section][subsection.row - 1]
        return item
    }
    
    func resetValues() {
        resetTerms()
        gradeItems = []
    }
    
    func loadItems(payload: [[[GradeItem]]]) {
        if payload.count == 0 {
            return
        }
        
        for i in 0..<payload.count {
            terms.append(payload[i][0][0].term)
            isHidden.append(true)
        }
        isHidden[0] = false
        gradeItems = payload
    }
    
    func getHeaderRowForSubsection(section:Int, indexPath:IndexPath) -> Int {
        var row:Int = 0
        
        for index in 0..<indexPath.section {
            row += gradeItems[section][index].count + 1
        }
        
        return row
    }
    
    func getSubsectionIndexPath(section:Int, row:Int) -> IndexPath {
        let termSection:[[GradeItem]] = gradeItems[section]
        
        var startRow:Int = row
        var subsection:Int = 0
        
        while startRow > 0 {
            //print("Section: \(section) Subsection: \(subsection) StartRow: \(startRow)")
            startRow -= (termSection[subsection].count + 1)
            if(startRow >= 0) {
                subsection += 1
            }
        }
        
        let subRow:Int = 0 - startRow
        
        return IndexPath(row: subRow, section: subsection)
    }
    
    func getSubsectionTitle(section:Int, subsection:Int) -> String? {
        let siteId:String = gradeItems[section][subsection][0].siteId
        let title:String? = DataHandler.shared.siteTitleMap[siteId]
        return title
    }
}
