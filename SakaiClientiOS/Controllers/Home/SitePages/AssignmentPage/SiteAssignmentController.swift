//
//  SiteAssignmentControllerCollectionViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/21/18.
//

import ReusableSource
import UIKit

class SiteAssignmentController: UICollectionViewController, SitePageController {
    
    var siteId: String?
    
    var siteAssignmentDataSourceDelegate: SiteAssignmentCollectionDataSourceDelegate!
    
    override func loadView() {
        super.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Assignments"
        
        guard let id = siteId else {
            return
        }
        
        siteAssignmentDataSourceDelegate = SiteAssignmentCollectionDataSourceDelegate(collectionView: super.collectionView!, siteId: id)
        siteAssignmentDataSourceDelegate.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            let storyboard = UIStoryboard(name: "AssignmentView", bundle: nil)
            let pages = storyboard.instantiateViewController(withIdentifier: "pagedController") as! PagesController
            let assignments = self.siteAssignmentDataSourceDelegate.provider.items
            pages.setAssignments(assignments: assignments, start: indexPath.row)
            self.navigationController?.pushViewController(pages, animated: true)
        }
        siteAssignmentDataSourceDelegate.textViewDelegate.delegate(to: self) { (self) -> UITextViewDelegate in
            return self
        }
        loadData()
        self.configureNavigationItem()
    }
}

extension SiteAssignmentController: LoadableController {
    @objc func loadData() {
        self.loadSource() {}
    }
}

extension SiteAssignmentController: NetworkController {
    var networkSource: SiteAssignmentCollectionDataSourceDelegate {
        return siteAssignmentDataSourceDelegate
    }
}
