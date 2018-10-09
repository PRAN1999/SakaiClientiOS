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

    func handleSectionLoad(forSection section: Int)

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
