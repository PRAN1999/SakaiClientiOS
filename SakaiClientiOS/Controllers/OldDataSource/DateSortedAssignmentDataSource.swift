//
//  DateSortedAssignmentDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/25/18.
//

import UIKit

class DateSortedAssignmentDataSource: BaseHideableTableDataSourceImplementation {
    
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
        assignmentDataSource.collectionViewDelegate = collectionViewDelegate
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
        DataHandler.shared.getAllAssignments(completion: { siteList in
            
            DispatchQueue.main.async {
                guard let list = siteList else {
                    completion()
                    return
                }
                
                if list.count == 0 {
                    completion()
                    return
                }
                
                super.numSections = list.count
                self.assignments = list
                
                for i in 0..<list.count {
                    super.terms.append(list[i][0].term)
                    let numRows:Int = 1
                    
                    super.numRows.append(numRows)
                    super.isHidden.append(true)
                }
                
                super.isHidden[0] = false
                
                completion()
            }
        })
    }
    
}
