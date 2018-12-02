//
//  SiteGradebookPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/22/18.
//

import ReusableSource

class SiteGradebookController: UITableViewController, SitePageController {
    
    var siteId: String
    var siteUrl: String
    var pageTitle: String

    var siteGradebookTableDataSource: SiteGradebookTableDataSource!

    required init(siteId: String, siteUrl: String, pageTitle: String) {
        self.siteId = siteId
        self.siteUrl = siteUrl
        self.pageTitle = pageTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Gradebook"
        
        siteGradebookTableDataSource = SiteGradebookTableDataSource(tableView: super.tableView, siteId: siteId)
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
