//
//  SiteAssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/21/18.
//

import ReusableSource
import UIKit

class SiteAssignmentController: UICollectionViewController, SitePageController {
    
    var siteId: String
    var siteUrl: String
    var pageTitle: String

    var siteAssignmentCollectionManager: SiteAssignmentCollectionManager!

    required init(siteId: String, siteUrl: String, pageTitle: String) {
        self.siteId = siteId
        self.siteUrl = siteUrl
        self.pageTitle = pageTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Assignments"
        
        siteAssignmentCollectionManager = SiteAssignmentCollectionManager(collectionView: super.collectionView!, siteId: siteId)
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
        configureNavigationItem()
        siteAssignmentCollectionManager.loadDataSource()
    }
}

extension SiteAssignmentController: LoadableController {
    @objc func loadData() {
        self.siteAssignmentCollectionManager.loadDataSourceWithoutCache()
    }
}

extension SiteAssignmentController: NetworkSourceDelegate {}
