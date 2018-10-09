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
    
    var fetcher: SiteDataFetcher
    
    convenience init(tableView: UITableView) {
        self.init(provider: SiteDataProvider(), tableView: tableView)
    }
    
    override init(provider: SiteDataProvider, tableView: UITableView) {
        fetcher = SiteDataFetcher()
        super.init(provider: provider, tableView: tableView)
    }
}
