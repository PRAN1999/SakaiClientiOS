//
//  SiteGradebookViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/22/18.
//

import ReusableSource

class SiteGradebookViewController: UITableViewController {
    
    private let siteId: String

    private lazy var siteGradebookManager
        = SiteGradebookTableManager(tableView: tableView, siteId: siteId)

    required init(siteId: String) {
        self.siteId = siteId
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
        
        siteGradebookManager.delegate = self
        configureNavigationItem()
        siteGradebookManager.loadDataSource()
    }
}

// MARK: LoadableController Extension

extension SiteGradebookViewController: LoadableController {
    @objc func loadData() {
        siteGradebookManager.loadDataSourceWithoutCache()
    }
}

// MARK: NetworkSourceDelegate Extension

extension SiteGradebookViewController: NetworkSourceDelegate {}
