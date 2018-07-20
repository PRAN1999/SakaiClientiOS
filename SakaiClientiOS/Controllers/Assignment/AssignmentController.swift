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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.tableView.allowsSelection = false
        super.tableView.register(AssignmentTableCell.self, forCellReuseIdentifier: AssignmentTableCell.reuseIdentifier)
        super.tableView.register(TermHeader.self, forHeaderFooterViewReuseIdentifier: TermHeader.reuseIdentifier)
        assignmentsTableDataSourceDelegate = AssignmentTableDataSourceDelegate(tableView: super.tableView)
        assignmentsTableDataSourceDelegate.controller = self
        createSegmentedControl()
        loadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadData))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setToolbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true
    }
    
    func createSegmentedControl() {
        segments = UISegmentedControl.init(items: ["Class", "Date"])
        
        segments.selectedSegmentIndex = selectedIndex
        segments.addTarget(self, action: #selector(resort), for: UIControlEvents.valueChanged)
        segments.tintColor = AppGlobals.SAKAI_RED
        segments.setEnabled(false, forSegmentAt: 1)
        
        button1 = UIBarButtonItem(customView: segments);
        button2 = UIBarButtonItem(customView: segments);
        flexButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    }
    
    func setToolbar() {
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.barTintColor = UIColor.black
        
        segments.frame = (self.navigationController?.toolbar.frame)!
        
        segments.translatesAutoresizingMaskIntoConstraints = false
        segments.setWidth(self.view.frame.size.width / 4, forSegmentAt: 0)
        segments.setWidth(self.view.frame.size.width / 4, forSegmentAt: 1)
        
        flexButton.width = self.view.frame.size.width / 4 - 15
        
        let arr:[UIBarButtonItem] = [flexButton, button1, button2, flexButton]
        
        self.navigationController?.toolbar.setItems(arr, animated: true)
    }
    
    @objc func resort() {
        assignmentsTableDataSourceDelegate.switchSort()
    }
    
    @objc func loadData() {
        segments.selectedSegmentIndex = 0
        segments.setEnabled(false, forSegmentAt: 1)
        assignmentsTableDataSourceDelegate.resetSort()
        loadSourceWithoutCache() {
            self.segments.setEnabled(true, forSegmentAt: 1)
        }
    }
    
}

extension AssignmentController: NetworkController {
    
    var networkSource : AssignmentTableDataSourceDelegate {
        return assignmentsTableDataSourceDelegate
    }
}
