//
//  SiteAssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/21/18.
//

import ReusableSource
import UIKit

class SiteAssignmentController: UICollectionViewController, SitePageController {
    
    var siteId: String?
    var siteUrl: String?
    
    var siteAssignmentCollectionManager: SiteAssignmentCollectionManager!
    
    override func loadView() {
        super.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Assignments"
        
        guard let id = siteId else {
            return
        }
        
        siteAssignmentCollectionManager = SiteAssignmentCollectionManager(collectionView: super.collectionView!, siteId: id)
        siteAssignmentCollectionManager.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            let storyboard = UIStoryboard(name: "AssignmentView", bundle: nil)
            guard let pages = storyboard.instantiateViewController(withIdentifier: "pagedController") as? PagesController else {
                return
            }
            let assignments = self.siteAssignmentCollectionManager.provider.items
            pages.setAssignments(assignments: assignments, start: indexPath.row)
            self.navigationController?.pushViewController(pages, animated: true)
        }
        siteAssignmentCollectionManager.textViewDelegate.delegate(to: self) { (self) -> UITextViewDelegate in
            return self
        }
        siteAssignmentCollectionManager.delegate = self
        siteAssignmentCollectionManager.loadDataSource()
        self.configureNavigationItem()
    }
}

extension SiteAssignmentController: LoadableController {
    @objc func loadData() {
        self.siteAssignmentCollectionManager.loadDataSourceWithoutCache()
    }
}

extension SiteAssignmentController: NetworkSourceDelegate {}
