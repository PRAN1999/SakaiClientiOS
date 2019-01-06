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
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: LandscapeHorizontalLayout())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Assignments"

        siteAssignmentCollectionManager.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            let assignments = self.siteAssignmentCollectionManager.provider.items
            let pages = PagesController(assignments: assignments, start: indexPath.row)
            pages.delegate = self.siteAssignmentCollectionManager
            self.siteAssignmentCollectionManager.selectedCell?.flip { [weak self] in
                self?.navigationController?.pushViewController(pages, animated: true)
            }
        }

        siteAssignmentCollectionManager.textViewDelegate = self
        siteAssignmentCollectionManager.delegate = self
        collectionView?.backgroundColor = Palette.main.primaryBackgroundColor

        configureNavigationItem()
        siteAssignmentCollectionManager.loadDataSource()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        siteAssignmentCollectionManager.flipIfNecessary()
    }
}

extension SiteAssignmentController: LoadableController {
    @objc func loadData() {
        siteAssignmentCollectionManager.loadDataSourceWithoutCache()
    }
}

extension SiteAssignmentController: NetworkSourceDelegate {}

extension SiteAssignmentController: Animatable {
    var containerView: UIView? {
        return collectionView
    }

    var childView: UIView? {
        return siteAssignmentCollectionManager.selectedCell
    }

    var childViewFrame: CGRect? {
        return siteAssignmentCollectionManager.selectedCellFrame
    }
}
