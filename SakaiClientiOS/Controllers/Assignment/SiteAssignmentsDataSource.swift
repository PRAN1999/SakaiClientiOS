//
//  SiteAssignmentsDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/10/18.
//

import Foundation
import UIKit

class SiteAssignmentsDataSource: BaseTableDataSourceImplementation {
    
    var assignments:[[[Assignment]]] = [[[Assignment]]]()
    var assignmentDataSources:[AssignmentDataSource] = [AssignmentDataSource]()
    var sites:[[Site]] = [[Site]]()
    
    var collectionViewDelegate: UICollectionViewDelegate?
    var textViewDelegate: UITextViewDelegate?
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AssignmentTableCell.reuseIdentifier, for: indexPath) as? AssignmentTableCell else {
            fatalError("Fail to dequeue cell")
        }
        
        let siteId:String = assignments[indexPath.section][indexPath.row][0].getSiteId()
        let title:String? = RequestManager.shared.siteTitleMap[siteId]
        
        cell.titleLabel.text = title
        cell.collectionView.register(AssignmentCell.self, forCellWithReuseIdentifier: AssignmentCell.reuseIdentifier)
        
        let assignmentDataSource = AssignmentDataSource()
        assignmentDataSource.textViewDelegate = textViewDelegate
        assignmentDataSource.loadData(list: assignments[indexPath.section][indexPath.row])
        assignmentDataSources.append(assignmentDataSource)
        
        cell.collectionView.dataSource = assignmentDataSource
        cell.collectionView.delegate = collectionViewDelegate
        cell.collectionView.reloadData()
        
        return cell
    }
    
    override func resetValues() {
        super.resetValues()
        sites = []
        assignments = []    }
    
    override func loadData(completion: @escaping () -> Void) {
        
        RequestManager.shared.getAllAssignmentsBySites(completion: { siteList in
            
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
                    self.terms.append(list[i][0][0].getTerm())
                    let numRows:Int = list[i].count
                    
                    self.numRows.append(numRows)
                    self.isHidden.append(true)
                }
                
                self.isHidden[0] = false
                
                completion()
            }
        })
    }
}
