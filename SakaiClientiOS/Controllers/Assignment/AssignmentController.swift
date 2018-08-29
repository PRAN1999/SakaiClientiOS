//
//  AssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit
import ReusableSource

class AssignmentController: UITableViewController {
    
    var assignmentsTableDataSourceDelegate: AssignmentTableDataSourceDelegate!
    
    var segments:UISegmentedControl!
    var button1: UIBarButtonItem!
    var button2: UIBarButtonItem!
    var flexButton: UIBarButtonItem!
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignmentsTableDataSourceDelegate = AssignmentTableDataSourceDelegate(tableView: super.tableView)
        assignmentsTableDataSourceDelegate.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            let storyboard = UIStoryboard(name: "AssignmentView", bundle: nil)
            let pages = storyboard.instantiateViewController(withIdentifier: "pagedController") as! PagesController
            guard let assignments = self.assignmentsTableDataSourceDelegate.item(at: indexPath) else {
                return
            }
            guard let start = self.assignmentsTableDataSourceDelegate.lastSelectedIndex else {
                return
            }
            pages.setAssignments(assignments: assignments, start: start)
            self.navigationController?.pushViewController(pages, animated: true)
        }
        assignmentsTableDataSourceDelegate.textViewDelegate.delegate(to: self) { (self) -> UITextViewDelegate in
            return self
        }
        
        createSegmentedControl()
        loadData()
        self.configureNavigationItem()
    }
    
    func createSegmentedControl() {
        segments = UISegmentedControl.init(items: ["Class", "Date"])
        
        segments.selectedSegmentIndex = selectedIndex
        segments.addTarget(self, action: #selector(resort), for: UIControlEvents.valueChanged)
        segments.tintColor = AppGlobals.SAKAI_RED
        segments.setEnabled(false, forSegmentAt: 1)
        
        button1 = UIBarButtonItem(customView: segments);
        button2 = UIBarButtonItem(customView: segments);
        flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.navigationController?.toolbar.barTintColor = UIColor.black
        let frame = self.view.frame
        
        segments.translatesAutoresizingMaskIntoConstraints = false
        segments.setWidth(frame.size.width / 4, forSegmentAt: 0)
        segments.setWidth(frame.size.width / 4, forSegmentAt: 1)
        
        let arr:[UIBarButtonItem] = [flexButton, button1, button2, flexButton]
        
        self.setToolbarItems(arr, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    @objc func resort() {
        assignmentsTableDataSourceDelegate.switchSort()
    }
}

extension AssignmentController: LoadableController {
    @objc func loadData() {
        segments.selectedSegmentIndex = 0
        segments.setEnabled(false, forSegmentAt: 1)
        assignmentsTableDataSourceDelegate.resetSort()
        self.loadControllerWithoutCache() {
            self.segments.setEnabled(true, forSegmentAt: 1)
        }
    }
}

extension AssignmentController: HideableNetworkController {
    var networkSource : AssignmentTableDataSourceDelegate {
        return assignmentsTableDataSourceDelegate
    }
}
