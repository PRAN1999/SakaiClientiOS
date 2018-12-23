//
//  AssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit
import ReusableSource

/// The root ViewController for the all Assignments tab and navigation hierarchy
class AssignmentController: UITableViewController {
    
    /// Abstract the Assignment data management to a dedicated TableViewManager
    private lazy var assignmentsTableManager = AssignmentTableManager(tableView: tableView)
    
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
            let pages = PagesController(assignments: assignments, start: row)
            self.navigationController?.pushViewController(pages, animated: true)
        }
        assignmentsTableManager.textViewDelegate.delegate(to: self) { (self) -> UITextViewDelegate in
            return self
        }
        assignmentsTableManager.delegate = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(presentFilter))

        configureNavigationItem()
        loadData()
    }

    @objc func resort() {
        assignmentsTableManager.switchSort()
    }

    @objc func presentFilter() {
        let storyboard = UIStoryboard(name: "AssignmentView", bundle: nil)
        guard let filterController = storyboard.instantiateViewController(withIdentifier: "filter") as? FilterViewController else {
            return
        }
        filterController.selectedIndex = sortedIndex
        filterController.filters = ["Class", "Date"]
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

//MARK: LoadableController

extension AssignmentController: LoadableController {
    @objc func loadData() {
        assignmentsTableManager.loadDataSourceWithoutCache()
    }
}

//MARK: NetworkSourceDelegate

extension AssignmentController: NetworkSourceDelegate {
    func networkSourceWillBeginLoadingData<Source>(_ networkSource: Source) -> (() -> Void)? where Source : NetworkSource {
        assignmentsTableManager.resetSort()
        sortedIndex = 0
        return addLoadingIndicator()
    }
}
