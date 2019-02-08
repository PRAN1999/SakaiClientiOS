//
//  SiteAssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/21/18.
//

import ReusableSource
import UIKit

/// A View Controller for a single Site's Assignments
class SiteAssignmentsViewController: UICollectionViewController {
    
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
                                          collectionViewLayout: UICollectionViewFlowLayout())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Assignments"

        siteAssignmentCollectionManager.selectedAt.delegate(to: self) {
            (self, indexPath) -> Void in
            let assignments = self.siteAssignmentCollectionManager.provider.items
            let pages = AssignmentPagesViewController(assignments: assignments, start: indexPath.row)
            pages.delegate = self.siteAssignmentCollectionManager

            // The UIView flip animation does not accurately perform in the
            // AnimationController, so the animation will take place in two
            // stages. First the cell will be flipped and on completion, the
            // actual ViewController transition will be kicked off
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
        // If transitioning back from a PagesController, the cell used for
        // the animation transition needs to be flipped to complete the effect
        siteAssignmentCollectionManager.flipIfNecessary()
    }
}

//MARK: LoadableController Extension

extension SiteAssignmentsViewController: LoadableController {
    @objc func loadData() {
        siteAssignmentCollectionManager.loadDataSourceWithoutCache()
    }
}

//MARK: NetworkSourceDelegate Extension

extension SiteAssignmentsViewController: NetworkSourceDelegate {}

//MARK: Animatable Extension

extension SiteAssignmentsViewController: Animatable {
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

extension SiteAssignmentsViewController: NavigationAnimatable {
    func animationControllerForPop(to controller: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

    func animationControllerForPush(to controller: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if controller is AssignmentPagesViewController {
            return ExpandPresentAnimationController(resizingDuration: 0.5)
        }
        return nil
    }
}
