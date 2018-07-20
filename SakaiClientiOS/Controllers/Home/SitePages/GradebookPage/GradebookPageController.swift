//
//  GradebookPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/22/18.
//

import ReusableSource

class GradebookPageController: UITableViewController {
    
    var siteId: String!
    var siteGradebookTableDataSource: GradebookPageTableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.tableView.allowsSelection = false
        super.tableView.register(GradebookCell.self, forCellReuseIdentifier: GradebookCell.reuseIdentifier)
        
        siteGradebookTableDataSource = GradebookPageTableDataSource(tableView: super.tableView, siteId: siteId)
        loadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadData))
    }
    
    @objc func loadData() {
        loadSource() {}
    }
}

extension GradebookPageController: NetworkController {
    var networkSource: GradebookPageTableDataSource {
        return siteGradebookTableDataSource
    }
}
