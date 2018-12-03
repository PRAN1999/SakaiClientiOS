//
//  SiteTableManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import UIKit
import ReusableSource

class SiteTableManager: HideableTableManager<SiteDataProvider, SiteCell>, NetworkSource {
    weak var delegate: NetworkSourceDelegate?
    typealias Fetcher = SiteDataFetcher
    
    let fetcher: SiteDataFetcher
    
    convenience init(tableView: UITableView) {
        self.init(provider: SiteDataProvider(), fetcher: SiteDataFetcher(), tableView: tableView)
    }
    
    init(provider: Provider, fetcher: Fetcher, tableView: UITableView) {
        self.fetcher = fetcher
        super.init(provider: provider, tableView: tableView)
    }
}
