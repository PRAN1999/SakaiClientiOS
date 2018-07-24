//
//  HideableDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/10/18.
//

import UIKit
import ReusableSource

class HideableNetworkTableDataSourceDelegate<Provider: HideableNetworkDataProvider, Cell: UITableViewCell & ConfigurableCell, Fetcher: HideableDataFetcher> : HideableTableDataSourceDelegate<Provider, Cell>, HideableNetworkSource where Provider.T == Cell.T, Provider.V == Fetcher.T {
    
    var fetcher: Fetcher
    
    init(provider: Provider, fetcher: Fetcher, tableView: UITableView) {
        self.fetcher = fetcher
        super.init(provider: provider, tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provider.numberOfItemsForHideableNetworkSection(section: section)
    }
    
    @objc override func handleTap(sender: UITapGestureRecognizer) {
        let section = (sender.view?.tag)!
        let view = sender.view as! TermHeader
        
        if provider.hasLoaded[section] {
            super.handleTap(sender: sender)
        } else {
            view.activityIndicator.startAnimating()
            loadDataSource(for: section) {
                view.activityIndicator.stopAnimating()
            }
        }
    }
}
