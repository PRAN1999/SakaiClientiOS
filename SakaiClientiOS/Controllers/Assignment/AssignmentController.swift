//
//  AssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit

class AssignmentController: CollapsibleSectionController {
    var siteAssignmentDataSource: SiteAssignmentsDataSource!
    var dateSortedAssignmentDataSource: DateSortedAssignmentDataSource!
    
    var dateSorted:Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        dateSortedAssignmentDataSource = DateSortedAssignmentDataSource()
        siteAssignmentDataSource  = SiteAssignmentsDataSource()
        super.init(coder: aDecoder, dataSource: dateSortedAssignmentDataSource)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false
        self.tableView.register(SiteAssignmentsCell.self, forCellReuseIdentifier: SiteAssignmentsCell.reuseIdentifier)
        self.tableView.register(DueDateAssignmentCell.self, forCellReuseIdentifier: DueDateAssignmentCell.reuseIdentifier)
        self.tableView.register(TermHeader.self, forHeaderFooterViewReuseIdentifier: TermHeader.reuseIdentifier)
        
        siteAssignmentDataSource.collectionViewDelegate = self
        siteAssignmentDataSource.textViewDelegate = self
        
        dateSortedAssignmentDataSource.collectionViewDelegate = self
        dateSortedAssignmentDataSource.textViewDelegate = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(resort))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func resort() {
        if dateSorted {
            dateSorted = false
            super.dataSource = siteAssignmentDataSource
            super.tableView.dataSource = siteAssignmentDataSource
            super.loadDataSource()
        } else {
            dateSorted = true
            super.dataSource = dateSortedAssignmentDataSource
            super.tableView.dataSource = dateSortedAssignmentDataSource
            super.loadDataSource()
        }
    }

}

extension AssignmentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "AssignmentView", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "pagedController") as! PagedAssignmentController
        let dataSource = collectionView.dataSource as! AssignmentDataSource
        controller.setAssignments(assignments: dataSource.assignments, start: indexPath.row)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension AssignmentController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size:CGSize!
        if dateSorted {
            size = CGSize(width: collectionView.bounds.width / 2.3, height: 200)
        } else {
            size = CGSize(width: collectionView.bounds.width / 2.5, height: collectionView.bounds.height)
        }
        
        return size
    }
}
