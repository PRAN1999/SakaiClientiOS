//
//  HideableNetworkSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/23/18.
//

import ReusableSource

/// A NetworkSource that is able to load data by Term.
/// Only current usage is with HideableNetworkTableManager
protocol HideableNetworkSource: NetworkSource where Self.Fetcher: HideableDataFetcher {

    /// Once section data has been returned from the network request, perform
    /// some action whether or not data load was successful
    ///
    /// - Parameter section: the section being loaded
    /// - Returns: no return value
    func handleSectionLoad(forSection section: Int)

    /// Loads data for the specified Term into the data source
    ///
    /// - Parameters:
    ///   - payload: the data to load
    ///   - section: the Term or section for the payload
    /// - Returns: No return value
    func populateDataSource(with payload: Fetcher.T, forSection section: Int)

    /// Load data for a specific section or Term
    ///
    /// - Parameters:
    ///   - section: the section to load data for
    ///   - completion: callback to execute when request is finished,
    ///                 regardless of success or failure
    func loadDataSource(for section: Int, completion: (() -> Void)?)
}

extension HideableNetworkSource {

    // Default implementation for loadDataSource(for:, completion:)

    func loadDataSource(for section: Int, completion: (() -> Void)?) {
        fetcher.loadData(for: section) { [weak self] res, err in
            DispatchQueue.main.async {
                completion?()
                self?.handleSectionLoad(forSection: section)
                if err != nil {
                    self?.delegate?.networkSourceFailedToLoadData(self, withError: err!)
                }
                if let response = res {
                    self?.populateDataSource(with: response, forSection: section)
                    self?.delegate?.networkSourceSuccessfullyLoadedData(self)
                }
            }
        }
    }
}
