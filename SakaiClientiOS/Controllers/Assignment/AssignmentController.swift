//
//  AssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit
import ReusableSource

class AssignmentController: UITableViewController {
    
    var assignmentsTableManager: AssignmentTableManager!
    
    var segments:UISegmentedControl!
    var button1: UIBarButtonItem!
    var button2: UIBarButtonItem!
    var flexButton: UIBarButtonItem!
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignmentsTableManager = AssignmentTableManager(tableView: super.tableView)
        assignmentsTableManager.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            let storyboard = UIStoryboard(name: "AssignmentView", bundle: nil)
            guard let pages = storyboard.instantiateViewController(withIdentifier: "pagedController") as? PagesController else {
                return
            }
            guard let assignments = self.assignmentsTableManager.item(at: indexPath) else {
                return
            }
            guard let start = self.assignmentsTableManager.lastSelectedIndex else {
                return
            }
            pages.setAssignments(assignments: assignments, start: start)
            self.navigationController?.pushViewController(pages, animated: true)
        }
        assignmentsTableManager.textViewDelegate.delegate(to: self) { (self) -> UITextViewDelegate in
            return self
        }
        assignmentsTableManager.delegate = self
        
        createSegmentedControl()
        loadData()
        self.configureNavigationItem()
    }
    
    func createSegmentedControl() {
        segments = UISegmentedControl.init(items: ["Class", "Date"])
        
        segments.selectedSegmentIndex = selectedIndex
        segments.addTarget(self, action: #selector(resort), for: UIControlEvents.valueChanged)
        segments.tintColor = AppGlobals.sakaiRed
        segments.setEnabled(false, forSegmentAt: 1)
        
        button1 = UIBarButtonItem(customView: segments);
        button2 = UIBarButtonItem(customView: segments);
        flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let frame = self.view.frame
        
        segments.translatesAutoresizingMaskIntoConstraints = false
        segments.setWidth(frame.size.width / 4, forSegmentAt: 0)
        segments.setWidth(frame.size.width / 4, forSegmentAt: 1)
        
        let arr:[UIBarButtonItem] = [flexButton, button1, button2, flexButton]
        
        self.setToolbarItems(arr, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationController?.toolbar.barTintColor = UIColor.black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    @objc func resort() {
        assignmentsTableManager.switchSort()
    }
}

extension AssignmentController: LoadableController {
    @objc func loadData() {
        assignmentsTableManager.loadDataSourceWithoutCache()
    }
}

extension AssignmentController: NetworkSourceDelegate {
    func networkSourceWillBeginLoadingData<Source>(_ networkSource: Source) -> (() -> Void)? where Source : NetworkSource {
        segments.selectedSegmentIndex = 0
        segments.setEnabled(false, forSegmentAt: 1)
        assignmentsTableManager.resetSort()
        return self.addLoadingIndicator()
    }

    func networkSourceSuccessfullyLoadedData<Source>(_ networkSource: Source?) where Source : NetworkSource {
        self.segments.setEnabled(true, forSegmentAt: 1)
    }
}
