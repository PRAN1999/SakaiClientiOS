//
//  HideableNetworkDataSourceDelegate.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/29/18.
//

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
    
    func loadDataSource(completion: @escaping () -> Void) {
        resetValues()
        reloadData()
        loadDataSource(for: 0) {
            completion()
        }
    }
    
    func loadDataSource(for section:Int, completion: @escaping () -> Void) {
        fetcher.loadData(for: section) { [weak self] (res) in
            DispatchQueue.main.async {
                self?.provider.hasLoaded[section] = true
                self?.provider.isHidden[section] = false
                guard let payload = res else {
                    completion()
                    return
                }
                self?.provider.loadItems(payload: payload, for: section)
                self?.reloadData(for: section)
                completion()
            }
        }
    }
}
