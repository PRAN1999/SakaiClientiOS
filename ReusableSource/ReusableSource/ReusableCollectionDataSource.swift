//
//  ReusableCollectionDataSource.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/15/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

/// A generic implementation for a UICollectionViewDataSource with a
/// DataProvider and ConfigurableCell where the Provider and Cell deal with
/// the same associated model
open class ReusableCollectionDataSource
    <Provider: DataProvider, Cell: UICollectionViewCell & ConfigurableCell>
    : NSObject, UICollectionViewDataSource, ReusableSource
    where Provider.T == Cell.T {
    
    public let provider: Provider
    public let collectionView: UICollectionView

    /// Initialize the DataSource and setup the managed UICollectionView
    ///
    /// - Parameters:
    ///   - provider: A Provider object to populate the DataSource
    ///   - collectionView: The UICollectionView to manage within the data
    ///                     source
    public init(provider: Provider, collectionView: UICollectionView) {
        self.provider = provider
        self.collectionView = collectionView
        super.init()
        setup()
    }
    
    /// Assign the collectionView dataSource and register the associated
    /// Cell class with the collectionView
    open func setup() {
        collectionView.dataSource = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return provider.numberOfSections()
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             numberOfItemsInSection section: Int) -> Int {
        return provider.numberOfItems(in: section)
    }
    
    /// Provide a default implementation for returning and configuring a
    /// UICollectionViewCell making use of DataProvider and ConfigurableCell
    /// methods
    open func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Cell.reuseIdentifier,
                for: indexPath) as? Cell
            else {
            return UICollectionViewCell()
        }
        let item = provider.item(at: indexPath)
        if let item = item {
            cell.configure(item, at: indexPath)
            configureBehavior(for: cell, at: indexPath)
        }
        return cell
    }
    
    open func reloadData() {
        collectionView.reloadData()
    }
    
    open func reloadData(for section: Int) {
        collectionView.reloadSections([section])
    }

    open func reloadDataWithEmptyCheck() {
        reloadData()
    }
    
    open func loadItems(payload: Provider.V) {
        provider.loadItems(payload: payload)
    }
    
    open func resetValues() {
        provider.resetValues()
    }
    
    open func configureBehavior(for cell: Cell, at indexPath: IndexPath) {
        //Override and implement
        return
    }

    open func isEmpty() -> Bool {
        return provider.numberOfSections() == 0
    }
}
