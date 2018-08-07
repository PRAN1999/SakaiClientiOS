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
    
    /// An DataFetcher object used to retrieve data using HTTP requests
    var fetcher : Fetcher { get }
    
    /// Use the fetcher to make a network request and load data into the data source implementation
    ///
    /// - Parameter completion: The callback to execute once the data source has been loaded
    func loadDataSource(completion: @escaping () -> Void)
}

// MARK: - Default loadDataSource implementation for a ReusableSource where the DataProvider.V payload is equivalent to the associated Fetcher.T
public extension NetworkSource where Self:ReusableSource, Self.Provider.V == Self.Fetcher.T {
    
    /// Reset and reload data for data source and load fetcher response into DataProvider object if it isn't nil
    ///
    /// - Parameter completion: A callback for the controller to execute once the data source has been loaded.
    ///
    /// Expected to be used with a NetworkController implementation
    func loadDataSource(completion: @escaping () -> Void) {
        resetValues()
        reloadData()
        fetcher.loadData(completion: { [weak self] (res) in
            guard let response = res else {
                completion()
                return
            }
            DispatchQueue.main.async {
                self?.loadItems(payload: response)
                self?.reloadData()
                completion()
            }
        })
    }
}
