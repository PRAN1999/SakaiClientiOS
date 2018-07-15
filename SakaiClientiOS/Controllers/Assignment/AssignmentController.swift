//
//  AssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit
import ReusableSource

class AssignmentController: UITableViewController {
    
    var assignmentsTableSource: AssignmentTableSource!
    
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
        
        assignmentsTableSource = AssignmentTableSource(tableView: super.tableView)
        assignmentsTableSource.controller = self
        loadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadData))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setToolbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true
    }
    
    func setToolbar() {
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.barTintColor = UIColor.black
        
        segments = UISegmentedControl.init(items: ["Class", "Date"])
        segments.frame = (self.navigationController?.toolbar.frame)!
        
        segments.translatesAutoresizingMaskIntoConstraints = false
        segments.selectedSegmentIndex = selectedIndex
        segments.setWidth(self.view.frame.size.width / 4, forSegmentAt: 0)
        segments.setWidth(self.view.frame.size.width / 4, forSegmentAt: 1)
        segments.addTarget(self, action: #selector(resort), for: UIControlEvents.valueChanged)
        segments.tintColor = AppGlobals.SAKAI_RED
        
        button1 = UIBarButtonItem(customView: segments);
        button2 = UIBarButtonItem(customView: segments);
        flexButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        flexButton.width = self.view.frame.size.width / 4 - 15
        
        let arr:[UIBarButtonItem] = [flexButton, button1, button2, flexButton]
        
        self.navigationController?.toolbar.setItems(arr, animated: true)
    }
    
    @objc func resort() {
        
    }
    
    @objc func loadData() {
        loadSource() {}
    }
    
}

extension AssignmentController: NetworkController {
    
    var networkSource : AssignmentTableSource {
        return assignmentsTableSource
    }
}
