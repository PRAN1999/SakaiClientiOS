//
//  AssignmentsViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit
import ReusableSource

/// The root ViewController for the all Assignments tab and navigation hierarchy
class AssignmentsViewController: UITableViewController {
    
    /// Abstract the Assignment data management to a dedicated TableViewManager
    private lazy var assignmentsTableManager = AssignmentTableManager(tableView: tableView)

    private let filters = ["Class", "Date"]
    private var sortedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignmentsTableManager.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            self.assignmentsTableManager.toggleSite(at: indexPath)
        }
        assignmentsTableManager.selectedAssignmentAt.delegate(to: self) { (self, arg1) -> Void in
            // Navigate to a full page view for a selected Assignment
            let (indexPath, row) = arg1
            guard let assignments = self.assignmentsTableManager.item(at: indexPath) else {
                return
            }
            let pages = AssignmentPagesViewController(assignments: assignments, start: row)
            pages.delegate = self.assignmentsTableManager.selectedManager
            // The UIView flip animation does not accurately behave in the
            // AnimationController, so the animation will take place in two
            // stages. First the cell will be flipped and on completion, the
            // actual ViewController transition will be kicked off
            self.assignmentsTableManager.selectedManager?.selectedCell?.flip { [weak self] in
                self?.navigationController?.pushViewController(pages, animated: true)
            }
        }
        assignmentsTableManager.textViewDelegate = self
        assignmentsTableManager.delegate = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(presentFilter)
        )

        configureNavigationItem()
        loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // If transitioning back from a PagesController, the cell used for
        // the animation transition needs to be flip to complete the effect
        assignmentsTableManager.selectedManager?.flipIfNecessary()
    }

    @objc func resort() {
        assignmentsTableManager.switchSort()
    }

    @objc func presentFilter() {
        let storyboard = UIStoryboard(name: "AssignmentView", bundle: nil)
        guard
            let filterController = storyboard.instantiateViewController(withIdentifier: "filter")
                as? FilterViewController else {
            return
        }
        filterController.selectedIndex = sortedIndex
        filterController.filters = filters
        filterController.onCancel = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        filterController.onSet = { [weak self] index in
            self?.dismiss(animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                if index != self?.sortedIndex {
                    self?.resort()
                }
                self?.sortedIndex = index
            }
        }
        tabBarController?.present(filterController, animated: true, completion: nil)
    }
}

// MARK: LoadableController Extension

extension AssignmentsViewController: LoadableController {
    @objc func loadData() {
        assignmentsTableManager.loadDataSourceWithoutCache()
    }
}

// MARK: NetworkSourceDelegate Extension

extension AssignmentsViewController: NetworkSourceDelegate {
    func networkSourceWillBeginLoadingData<Source>(
        _ networkSource: Source
    ) -> (() -> Void)? where Source: NetworkSource {
        assignmentsTableManager.reset()
        sortedIndex = 0
        return addLoadingIndicator()
    }
}

extension AssignmentsViewController: Animatable {
    var containerView: UIView? {
        return assignmentsTableManager.selectedManager?.collectionView
    }

    var childView: UIView? {
        return assignmentsTableManager.selectedManager?.selectedCell
    }

    var childViewFrame: CGRect? {
        return assignmentsTableManager.selectedManager?.selectedCellFrame
    }
}

extension AssignmentsViewController: NavigationAnimatable {
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
