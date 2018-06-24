//
//  AssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit

class AssignmentController: CollapsibleSectionController {
    var siteAssignmentsDataSource: SiteAssignmentsDataSource!
    
    required init?(coder aDecoder: NSCoder) {
        siteAssignmentsDataSource  = SiteAssignmentsDataSource()
        super.init(coder: aDecoder, dataSource: siteAssignmentsDataSource)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false
        self.tableView.register(SiteAssignmentsCell.self, forCellReuseIdentifier: SiteAssignmentsCell.reuseIdentifier)
        self.tableView.register(TermHeader.self, forHeaderFooterViewReuseIdentifier: TermHeader.reuseIdentifier)
        
        siteAssignmentsDataSource.collectionViewDelegate = self
        siteAssignmentsDataSource.textViewDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension AssignmentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
        let storyboard = UIStoryboard(name: "AssignmentView", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "pagedController") as! PagedAssignmentController
        let dataSource = collectionView.dataSource as! AssignmentDataSource
        controller.setAssignments(assignments: dataSource.assignments, start: indexPath.row)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension AssignmentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.bounds.width / 2.5, height: collectionView.bounds.height)
        return size
    }
}

extension AssignmentController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let webController = WebController()
        webController.setURL(url: URL)
        
        navigationController?.pushViewController(webController, animated: true)
        
        return false
    }
}
