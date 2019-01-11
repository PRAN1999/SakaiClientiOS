//
//  SiteAssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/21/18.
//

import ReusableSource
import UIKit

/// A View Controller for a single Site's Assignments
class SiteAssignmentController: UICollectionViewController {
    
    private let siteId: String

    private lazy var siteAssignmentCollectionManager =
        SiteAssignmentCollectionManager(collectionView: collectionView!,
                                        siteId: siteId)

    required init(siteId: String) {
        self.siteId = siteId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: LandscapeHorizontalLayout())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Assignments"

        siteAssignmentCollectionManager.selectedAt.delegate(to: self) {
            (self, indexPath) -> Void in
            let assignments = self.siteAssignmentCollectionManager.provider.items
            let pages = PagesController(assignments: assignments,
                                        start: indexPath.row)
            pages.delegate = self.siteAssignmentCollectionManager

            // The UIView flip animation does not accurately perform in the
            // AnimationController, so the animation will take place in two
            // stages. First the cell will be flipped and on completion, the
            // actual ViewController transition will be kicked off
            self.siteAssignmentCollectionManager.selectedCell?.flip {
                [weak self] in
                self?.navigationController?.pushViewController(pages,
                                                               animated: true)
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
        // If transitioning back from a PagesController, the cell used for
        // the animation transition needs to be flip to complete the effect
        siteAssignmentCollectionManager.flipIfNecessary()
    }
}

//MARK: LoadableController Extension

extension SiteAssignmentController: LoadableController {
    @objc func loadData() {
        siteAssignmentCollectionManager.loadDataSourceWithoutCache()
    }
}

//MARK: NetworkSourceDelegate Extension

extension SiteAssignmentController: NetworkSourceDelegate {}

//MARK: Animatable Extension

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
