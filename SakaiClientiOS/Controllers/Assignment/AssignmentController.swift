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
    
    private let segments: UISegmentedControl = {
        let segments = UISegmentedControl.init(items: ["Class", "Date"])
        segments.tintColor = AppGlobals.sakaiRed
        segments.setEnabled(false, forSegmentAt: 1)
        segments.translatesAutoresizingMaskIntoConstraints = false
        return segments
    }()

    private lazy var button1: UIBarButtonItem = UIBarButtonItem(customView: segments)
    private lazy var button2: UIBarButtonItem = UIBarButtonItem(customView: segments)
    private let flexButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    private var selectedIndex = 0
    
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

        configureSegmentedControl()
        configureNavigationItem()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.toolbar.barTintColor = UIColor.black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
        navigationController?.toolbar.barTintColor = AppGlobals.defaultTint
    }
}

//MARK: View construction

fileprivate extension AssignmentController {

    @objc func resort() {
        assignmentsTableManager.switchSort()
    }

    /// Configures UI control to toggle between class and date(Term) sort
    func configureSegmentedControl() {
        segments.selectedSegmentIndex = selectedIndex
        segments.addTarget(self, action: #selector(resort), for: UIControlEvents.valueChanged)

        let frame = view.frame

        segments.setWidth(frame.size.width / 4, forSegmentAt: 0)
        segments.setWidth(frame.size.width / 4, forSegmentAt: 1)

        let arr: [UIBarButtonItem] = [flexButton, button1, button2, flexButton]
        setToolbarItems(arr, animated: true)
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
        segments.selectedSegmentIndex = 0
        segments.setEnabled(false, forSegmentAt: 1)
        assignmentsTableManager.resetSort()
        return addLoadingIndicator()
    }

    func networkSourceSuccessfullyLoadedData<Source>(_ networkSource: Source?) where Source : NetworkSource {
        segments.setEnabled(true, forSegmentAt: 1)
    }
}
