//
//  SiteTableManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import UIKit
import ReusableSource

/// Manage Term-based Site data by fetching data and loading into UITableView
class SiteTableManager: HideableTableManager<SiteDataProvider, SiteCell>, NetworkSource {

    weak var delegate: NetworkSourceDelegate?
    typealias Fetcher = SiteDataFetcher
    
    /// The data fetcher used to make a network call and fetch site data for
    /// the manager to load into the UITableView
    let fetcher: SiteDataFetcher
    
    convenience init(tableView: UITableView) {
        self.init(provider: SiteDataProvider(),
                  fetcher: SiteDataFetcher(
                             cacheUpdateService: SakaiService.shared,
                             networkService: RequestManager.shared
                           ),
                  tableView: tableView)
    }
    
    init(provider: Provider, fetcher: Fetcher, tableView: UITableView) {
        self.fetcher = fetcher
        super.init(provider: provider, tableView: tableView)
    }

    override func setup() {
        super.setup()
        // Remove trailing and leading spaces at top and bottom of UITableView
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        
        tableView.backgroundColor = Palette.main.primaryBackgroundColor
        tableView.separatorColor = Palette.main.tableViewSeparatorColor
        tableView.indicatorStyle = Palette.main.scrollViewIndicatorStyle
    }
}
