//
//  HideableNetworkTableManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/29/18.
//

import ReusableSource

/// A base HideableNetworkSource implementation that integrates section
/// data load with UI interaction. If a section has not been loaded, it will
/// be loaded and then data will be shown. If data has been loaded for that
/// section, it will function as it would for a HideableTableManager and
/// will toggle the section's visibility
class HideableNetworkTableManager
    <
        Provider: HideableNetworkDataProvider,
        Cell: UITableViewCell & ConfigurableCell,
        Fetcher: HideableDataFetcher
    >
    : HideableTableManager<Provider, Cell>, HideableNetworkSource
    where Provider.T == Cell.T, Provider.V == Fetcher.T {

    weak var delegate: NetworkSourceDelegate?

    let fetcher: Fetcher
    
    init(provider: Provider, fetcher: Fetcher, tableView: UITableView) {
        self.fetcher = fetcher
        super.init(provider: provider, tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return provider.numberOfItemsForHideableNetworkSection(section: section)
    }
    
    /// If the section has not been loaded, load the tapped section,
    /// otherwise use the default toggle in HideableTableManager
    ///
    /// - Parameter sender: the tapped header view
    @objc override func handleTap(sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else {
            return
        }
        guard let view = sender.view as? TermHeader else {
            return
        }
        
        if provider.hasLoaded(section: section) {
            super.handleTap(sender: sender)
        } else {
            view.activityIndicator.startAnimating()
            loadDataSource(for: section) {
                view.activityIndicator.stopAnimating()
            }
        }
    }

    func handleSectionLoad(forSection section: Int) {
        provider.toggleLoaded(for: section, to: !provider.hasLoaded(section: section))
        provider.toggleHidden(for: section, to: !provider.isHidden(section: section))
    }

    func populateDataSource(with payload: Fetcher.T,
                            forSection section: Int) {
        provider.loadItems(payload: payload, for: section)
        reloadData(for: section)
    }

    func loadDataSource() {
        let callback = self.delegate?.networkSourceWillBeginLoadingData(self)
        prepareDataSourceForLoad()
        loadDataSource(for: 0, completion: callback)
    }
}
