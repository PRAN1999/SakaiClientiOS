//
//  SiteAssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/21/18.
//

import ReusableSource
import UIKit

class SiteAssignmentController: UICollectionViewController, SitePageController {
    
    private let siteId: String
    private let siteUrl: String

    private lazy var siteAssignmentCollectionManager = SiteAssignmentCollectionManager(collectionView: collectionView!, siteId: siteId)

    required init(siteId: String, siteUrl: String, pageTitle: String) {
        self.siteId = siteId
        self.siteUrl = siteUrl
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Assignments"

        siteAssignmentCollectionManager.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            let assignments = self.siteAssignmentCollectionManager.provider.items
            let pages = PagesController(assignments: assignments, start: indexPath.row)
            self.navigationController?.pushViewController(pages, animated: true)
        }
        siteAssignmentCollectionManager.textViewDelegate.delegate(to: self) { (self) -> UITextViewDelegate in
            return self
        }
        siteAssignmentCollectionManager.delegate = self
        collectionView?.backgroundColor = UIColor.darkGray

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
