//
//  HideableNetworkTableManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/29/18.
//

import ReusableSource

/// A base NetworkSource implementation that integrates section
/// data load with UI interaction. If a section has not been loaded, it will
/// be loaded and then data will be shown. If data has been loaded for that
/// section, it will function as it would for a HideableTableManager and
/// will toggle the section's visibility
class HideableNetworkTableManager
    <Provider: HideableNetworkDataProvider, Cell: UITableViewCell & ConfigurableCell, Fetcher: HideableDataFetcher>
    : HideableTableManager<Provider, Cell>, NetworkSource
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

    /// Loads data for the specified Term into the data source
    ///
    /// - Parameters:
    ///   - payload: the data to load
    ///   - section: the Term or section for the payload
    /// - Returns: No return value
    func handleSectionLoad(forSection section: Int) {
        provider.toggleLoaded(for: section, to: !provider.hasLoaded(section: section))
        provider.toggleHidden(for: section, to: !provider.isHidden(section: section))
    }

    /// Load data for a specific section or Term
    ///
    /// - Parameters:
    ///   - section: the section to load data for
    ///   - completion: callback to execute when request is finished,
    ///                 regardless of success or failure
    func populateDataSource(with payload: Fetcher.T,
                            forSection section: Int) {
        provider.loadItems(payload: payload, for: section)
        reloadData(for: section)
    }

    /// Once section data has been returned from the network request,
    /// perform some action whether or not data load was successful
    ///
    /// - Parameter section: the section being loaded
    func loadDataSource() {
        let callback = self.delegate?.networkSourceWillBeginLoadingData(self)
        prepareDataSourceForLoad()
        loadDataSource(for: 0, completion: callback)
    }

    func loadDataSource(for section: Int, completion: (() -> Void)?) {
        DispatchQueue.global().async { [weak self] in
            self?.fetcher.loadData(for: section) { res, err in
                DispatchQueue.main.async {
                    completion?()
                    self?.handleSectionLoad(forSection: section)
                    if err != nil {
                        self?.delegate?.networkSourceFailedToLoadData(self, withError: err!)
                    }
                    if let response = res {
                        self?.populateDataSource(with: response,
                                                 forSection: section)
                        self?.delegate?.networkSourceSuccessfullyLoadedData(self)
                    }
                }
            }
        }
    }
}
