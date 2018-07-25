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
        super.collectionView?.backgroundColor = UIColor.white
        super.collectionView?.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        guard let id = siteId else {
            return
        }
        siteAssignmentDataSourceDelegate = SiteAssignmentCollectionDataSourceDelegate(collectionView: super.collectionView!, siteId: id)
        siteAssignmentDataSourceDelegate.controller = self
        loadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadData))
    }

    @objc func loadData() {
        loadSource() {}
    }
}

extension SiteAssignmentController: NetworkController {
    var networkSource: SiteAssignmentCollectionDataSourceDelegate {
        return siteAssignmentDataSourceDelegate
    }
}
