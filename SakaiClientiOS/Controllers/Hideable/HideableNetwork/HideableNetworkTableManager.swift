//
//  HideableNetworkTableManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/29/18.
//

import ReusableSource

/// A base HideableNetworkSource implementation that integrates section data load with UI interaction
class HideableNetworkTableManager<Provider: HideableNetworkDataProvider, Cell: UITableViewCell & ConfigurableCell, Fetcher: HideableDataFetcher> : HideableTableManager<Provider, Cell>, HideableNetworkSource where Provider.T == Cell.T, Provider.V == Fetcher.T {

    weak var delegate: NetworkSourceDelegate?

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
        guard let view = sender.view as? TermHeader else {
            return
        }
        
        if provider.hasLoaded[section] {
            super.handleTap(sender: sender)
        } else {
            view.activityIndicator.startAnimating()
            loadDataSource(for: section) {
                view.activityIndicator.stopAnimating()
            }
        }
    }

    func handleSectionLoad(forSection section: Int) {
        guard section < self.provider.hasLoaded.count, section < self.provider.isHidden.count else {
            return
        }
        self.provider.hasLoaded[section] = true
        self.provider.isHidden[section] = false
    }

    func populateDataSource(with payload: Fetcher.T, forSection section: Int) {
        self.provider.loadItems(payload: payload, for: section)
        self.reloadData(for: section)
    }
}
