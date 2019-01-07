//
//  DataProvider.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/11/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

/// A provider to abstract the data source for a UITableViewDataSource
/// or UICollectionViewDataSource by providing model objects for every
/// indexPath and managing the data needed to populate the table or
/// collection. Intended for use with ReusableSource.
///
/// Also provides methods for number of data sections and number of
/// data objects per section for direct interfacing from corresponding
/// DataSource methods
public protocol DataProvider {
    
    /// The item type associated with the Provider and to be returned
    /// to the DataSource cellForRowAt methods
    associatedtype T
    
    /// The payload type to load into the Provider to manage a data
    /// structure containing items of type T
    associatedtype V
    
    /// Returns the number of sections in the data for corresponding
    /// UITableViewDataSource and UICollectionViewDataSource methods
    ///
    /// - Returns: number of different sections in managed data
    func numberOfSections() -> Int
    
    /// Returns the number of data objects for a specific section for
    /// corresponding UITableViewDataSource and UICollectionViewDataSource
    /// methods
    ///
    /// - Parameter section: The section of the tableView/collectionView
    ///                      requesting data
    /// - Returns: The number of items in a section
    func numberOfItems(in section: Int) -> Int
    
    /// Returns the item needed to configure a UITableViewCell or
    /// UICollectionViewCell
    ///
    /// - Parameter indexPath: The indexPath for the cell
    /// - Returns: Item of type T to configure cell
    func item(at indexPath: IndexPath) -> T?
    
    /// Reset internal managed data, often for reloading/resetting
    /// ReusableSource
    func resetValues()
    
    /// Load or set internal managed data with payload of type V
    ///
    /// Often used in conjunction with DataFetcher in a NetworkSource,
    /// but does not have to be
    ///
    /// - Parameter payload: An item of type V to load into DataProvider
    ///                      managed data - is often a nested Array of T.
    func loadItems(payload: V)
}
