//
//  GradebookPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/22/18.
//

import ReusableSource

class SiteGradebookController: UITableViewController {
    
    var siteId: String!
    var siteGradebookTableDataSource: SiteGradebookTableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.tableView.allowsSelection = false
        super.tableView.register(GradebookCell.self, forCellReuseIdentifier: GradebookCell.reuseIdentifier)
        
        siteGradebookTableDataSource = SiteGradebookTableDataSource(tableView: super.tableView, siteId: siteId)
        loadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadData))
    }
    
    @objc func loadData() {
        loadSource() {}
    }
}

extension SiteGradebookController: NetworkController {
    var networkSource: SiteGradebookTableDataSource {
        return siteGradebookTableDataSource
    }
}
