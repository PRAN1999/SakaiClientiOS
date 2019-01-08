//
//  SiteGradebookPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/22/18.
//

import ReusableSource

class SiteGradebookController: UITableViewController, SitePageController {
    
    private let siteId: String
    private let siteUrl: String

    private lazy var siteGradebookTableDataSource
        = SiteGradebookTableDataSource(tableView: tableView, siteId: siteId)

    required init(siteId: String, siteUrl: String, pageTitle: String) {
        self.siteId = siteId
        self.siteUrl = siteUrl
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gradebook"
        tableView.tableFooterView = UIView()
        view.backgroundColor = Palette.main.primaryBackgroundColor
        tableView.separatorColor = Palette.main.tableViewSeparatorColor
        tableView.indicatorStyle = Palette.main.scrollViewIndicatorStyle
        
        siteGradebookTableDataSource.delegate = self
        configureNavigationItem()
        siteGradebookTableDataSource.loadDataSource()
    }
}

//MARK: LoadableController Extension

extension SiteGradebookController: LoadableController {
    @objc func loadData() {
        siteGradebookTableDataSource.loadDataSourceWithoutCache()
    }
}

//MARK: NetworkSourceDelegate Extension

extension SiteGradebookController: NetworkSourceDelegate {}
