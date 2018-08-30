//
//  NetworkSource.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/14/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

/// An abstraction for a network delegate used to retrieve network data and populate a data source
public protocol NetworkSource: class {

    /// The DataFetcher implementation type associated with the NetworkSource
    associatedtype Fetcher : DataFetcher

    var delegate: NetworkSourceDelegate? { get set }
    
    /// An DataFetcher object used to retrieve data using HTTP requests
    var fetcher : Fetcher { get }

    func prepareDataSourceForLoad()
    
    func populateDataSource(with payload: Fetcher.T)

    func loadDataSource()
}

public extension NetworkSource {
    func loadDataSource() {
        prepareDataSourceForLoad()
        let callback = delegate?.networkSource(willBeginLoadingDataSource: self)
        fetcher.loadData() { [weak self] res, err in
            callback?()
            guard err == nil, let response = res else {
                self?.delegate?.networkSource(errorLoadingDataSource: self, withError: err)
                return
            }
            self?.populateDataSource(with: response)
            self?.delegate?.networkSource(successfullyLoadedDataSource: self)
        }
    }
}

// MARK: - Default implementation for a ReusableSource where the DataProvider.V payload is equivalent to the associated Fetcher.T
public extension NetworkSource where Self: ReusableSource, Self.Provider.V == Self.Fetcher.T {
    func prepareDataSourceForLoad() {
        resetValues()
        reloadData()
    }

    func populateDataSource(with payload: Fetcher.T) {
        loadItems(payload: payload)
        reloadData()
    }
}
