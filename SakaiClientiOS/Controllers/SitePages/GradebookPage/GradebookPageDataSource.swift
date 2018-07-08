//
//  GradebookPageDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/8/18.
//

import UIKit

class GradebookPageDataSource : BaseTableDataSourceImplementation {
    
    var siteId:String!
    var gradeItems:[GradeItem] = [GradeItem]()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GradebookCell.reuseIdentifier, for: indexPath) as? GradebookCell else {
            fatalError("Not a gradebook cell")
        }
        
        let gradeItem = gradeItems[indexPath.row]
        
        var grade:String
        if gradeItem.grade != nil {
            grade = "\(gradeItem.grade!)"
        } else {
            grade = ""
        }
        
        cell.titleLabel.text = gradeItem.title
        cell.gradeLabel.text = "\(grade) / \(gradeItem.points)"
        
        return cell
    }
    
    override func resetValues() {
        super.resetValues()
        super.numRows = [0]
        gradeItems = []
    }
    
    override func loadData(completion: @escaping () -> Void) {
        DataHandler.shared.getSiteGrades(siteId: siteId) { res in
            
            DispatchQueue.main.async {
                print("Loading Site grades")
                
                guard let grades = res else {
                    return
                }
                
                super.numRows[0] = grades.count
                super.numSections = 1
                
                self.gradeItems = grades
                
                completion()
            }
        }
    }
    
}
