//
//  NetworkSource.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/14/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

/// An abstraction for a network-based data source used to retrieve
/// network data and populate a data source
public protocol NetworkSource: class {

    /// The DataFetcher implementation type associated with the
    /// NetworkSource
    associatedtype Fetcher: DataFetcher

    /// The delegate for the NetworkSource. MAKE SURE to mark it weak in
    /// implementation
    var delegate: NetworkSourceDelegate? { get set }
    
    /// An DataFetcher object used to retrieve data using HTTP requests
    var fetcher: Fetcher { get }

    /// Executed before fetching and loading data
    func prepareDataSourceForLoad()
    
    /// If data is successfully fetched, loads data into the data source
    ///
    /// - Parameter payload: data to load
    func populateDataSource(with payload: Fetcher.T)

    /// Fetch data using a data fetcher and load it into the associated
    /// data source
    func loadDataSource()
}

public extension NetworkSource {
    func loadDataSource() {
        prepareDataSourceForLoad()
        let callback = delegate?.networkSourceWillBeginLoadingData(self)
        DispatchQueue.global().async { [weak self] in
            self?.fetcher.loadData { res, err in
                DispatchQueue.main.async {
                    callback?()
                    // It is possible to encounter both failures and success
                    // when loading data (Dispatch Groups) so it possible
                    // both delegate methods will execute
                    if err != nil {
                        self?.delegate?.networkSourceFailedToLoadData(self, withError: err!)
                    }
                    if let response = res {
                        self?.populateDataSource(with: response)
                        self?.delegate?.networkSourceSuccessfullyLoadedData(self)
                    }
                }
            }
        }
    }
}

// MARK: - ReusableSource default impl.
public extension NetworkSource where Self: ReusableSource,
                                     Self.Provider.V == Self.Fetcher.T {
    func prepareDataSourceForLoad() {
        resetValues()
        reloadData()
    }

    func populateDataSource(with payload: Fetcher.T) {
        loadItems(payload: payload)
        reloadDataWithEmptyCheck()
    }
}
