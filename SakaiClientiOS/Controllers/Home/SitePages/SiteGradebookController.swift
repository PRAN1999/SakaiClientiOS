//
//  SiteGradebookPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/22/18.
//

import ReusableSource

class SiteGradebookController: UITableViewController, SitePageController {
    
    var siteId: String?
    var siteUrl: String?
    var pageTitle: String?
    var siteGradebookTableDataSource: SiteGradebookTableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Gradebook"
        
        guard let id = siteId else {
            return
        }
        
        siteGradebookTableDataSource = SiteGradebookTableDataSource(tableView: super.tableView, siteId: id)
        siteGradebookTableDataSource.delegate = self
        configureNavigationItem()
        siteGradebookTableDataSource.loadDataSource()
    }
}

extension SiteGradebookController: LoadableController {
    @objc func loadData() {
        siteGradebookTableDataSource.loadDataSourceWithoutCache()
    }
}

extension SiteGradebookController: NetworkSourceDelegate {}
