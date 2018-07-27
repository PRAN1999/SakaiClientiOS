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
        
        guard let id = siteId else {
            return
        }
        
        siteAssignmentDataSourceDelegate = SiteAssignmentCollectionDataSourceDelegate(collectionView: super.collectionView!, siteId: id)
        siteAssignmentDataSourceDelegate.controller = self
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
