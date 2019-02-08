//
//  ReusableSource.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/14/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

/// An abstraction representing a DataSource for a UITableView OR
/// UICollectionView with a unique DataProvider and ConfigurableCell
public protocol ReusableSource: class {
    
    /// The ConfigurableCell associated with the DataSource
    associatedtype Cell: ConfigurableCell
    
    /// The DataProvider associated with the DataSource constrained to
    /// deal with the same model as the Cell type
    associatedtype Provider: DataProvider where Cell.T == Provider.T
    
    var provider: Provider { get }
    
    /// Reset data source by purging provider managed data
    func resetValues()
    
    /// A wrapper to reload the data for the managed tableView or
    /// collectionView
    func reloadData()

    func reloadDataWithEmptyCheck()
    
    /// A wrapper for the managed tableView/collectionView reload methods
    /// at a specific section
    ///
    /// - Parameter section: The section at which data should be reloaded
    func reloadData(for section: Int)
    
    /// A wrapper for DataProvider loadItems
    ///
    /// - Parameter payload: The payload to load into provider
    func loadItems(payload: Provider.V)
    
    /// Add further configuration to Cell object being dequeued at a
    /// specific indexPath beyond the Cell.configure(item, at: indexPath)
    ///
    /// - Parameters:
    ///   - cell: The cell dequeued of type Cell.self
    ///   - indexPath: The indexPath for the cell being dequeued
    func configureBehavior(for cell: Cell, at indexPath: IndexPath)

    func isEmpty() -> Bool
}
