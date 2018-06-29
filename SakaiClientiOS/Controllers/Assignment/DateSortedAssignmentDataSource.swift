//
//  DateSortedAssignmentDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/25/18.
//

import UIKit

class DateSortedAssignmentDataSource: HideableTableDataSourceImplementation {
    
    var assignments:[[Assignment]] = [[Assignment]]()
    var assignmentDataSources:[AssignmentDataSource] = [AssignmentDataSource]()
    
    var collectionViewDelegate: UICollectionViewDelegate?
    var textViewDelegate: UITextViewDelegate?

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AssignmentTableCell.reuseIdentifier, for: indexPath) as? AssignmentTableCell else {
            fatalError("Fail to dequeue cell")
        }
        
        cell.titleLabel.text = "All Assignments"
        
        cell.collectionView.register(AssignmentCell.self, forCellWithReuseIdentifier: AssignmentCell.reuseIdentifier)
        
        let assignmentDataSource = AssignmentDataSource()
        assignmentDataSource.textViewDelegate = textViewDelegate
        assignmentDataSource.loadData(list: assignments[indexPath.section])
        assignmentDataSources.append(assignmentDataSource)
        
        cell.collectionView.dataSource = assignmentDataSource
        cell.collectionView.delegate = collectionViewDelegate
        cell.collectionView.reloadData()
        
        return cell
    }
    
    override func resetValues() {
        super.resetValues()
        assignments = []
    }
    
    override func loadData(completion: @escaping () -> Void) {
        RequestManager.shared.getAllAssignments(completion: { siteList in
            
            DispatchQueue.main.async {
                guard let list = siteList else {
                    return
                }
                
                if list.count == 0 {
                    return
                }
                
                self.numSections = list.count
                self.assignments = list
                
                for i in 0..<list.count {
                    self.terms.append(list[i][0].getTerm())
                    let numRows:Int = 1
                    
                    self.numRows.append(numRows)
                    self.isHidden.append(true)
                }
                
                self.isHidden[0] = false
                
                completion()
            }
        })
    }
    
}
