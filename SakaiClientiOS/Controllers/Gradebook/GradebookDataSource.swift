//
//  GradebookDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/3/18.
//

import Foundation
import UIKit

class GradebookDataSource: BaseTableDataSourceImplementation {
    
    var gradeItems:[[[GradeItem]]] = [[[GradeItem]]]()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subsectionIndex = getSubsectionIndexPath(section: indexPath.section, row: indexPath.row)
        
        if subsectionIndex.row == 0 {
            return getSiteTitleCell(tableView: tableView, indexPath: indexPath, subsection: subsectionIndex.section)
        } else {
            return getGradebookCell(tableView: tableView, indexPath: indexPath, subsection: subsectionIndex.section, row: subsectionIndex.row - 1)
        }
    }
    
    override func resetValues() {
        super.resetValues()
        gradeItems = []
    }
    
    override func loadData(completion: @escaping () -> Void) {
        RequestManager.shared.getAllGrades { res in
            DispatchQueue.main.async {
                print("Loading all grades")
                
                guard let list = res else {
                    return
                }
                
                self.numSections = list.count
                self.gradeItems = list
                
                for i in 0..<self.numSections {
                    self.terms.append(list[i][0][0].getTerm())
                    var numRows:Int = list[i].count
                    
                    for j in 0..<list[i].count {
                        numRows += list[i][j].count
                    }
                    self.numRows.append(numRows)
                    self.isHidden.append(true)
                }
                
                self.isHidden[0] = false
                
                completion()
            }
        }
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
    
    func getGradebookCell(tableView: UITableView, indexPath: IndexPath, subsection:Int, row:Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GradebookCell.reuseIdentifier, for: indexPath) as? GradebookCell else {
            fatalError("Not a gradebook cell")
        }
        
        //print("Subsection: \(subsection) Row: \(row)")
        let gradeItem:GradeItem = gradeItems[indexPath.section][subsection][row]
        
        var grade:String
        if gradeItem.getGrade() != nil {
            grade = "\(gradeItem.getGrade()!)"
        } else {
            grade = ""
        }
        
        cell.titleLabel.text = gradeItem.getTitle()
        cell.gradeLabel.text = "\(grade) / \(gradeItem.getPoints())"
        
        return cell
    }
    
    func getSiteTitleCell(tableView:UITableView, indexPath: IndexPath, subsection:Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SiteCell.reuseIdentifier, for: indexPath) as? SiteCell else {
            fatalError("Not a site cell")
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.none
        cell.titleLabel.text = getSubsectionTitle(section: indexPath.section, subsection: subsection)
        cell.backgroundColor = UIColor(red: 199 / 255.0, green: 37 / 255.0, blue: 78 / 255.0, alpha: 1.0)
        
        return cell
    }
    
    func getSubsectionTitle(section:Int, subsection:Int) -> String? {
        let siteId:String = gradeItems[section][subsection][0].getSiteId()
        let title:String? = AppGlobals.siteTitleMap[siteId]
        return title
    }
}
