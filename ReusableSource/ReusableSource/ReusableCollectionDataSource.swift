//
//  ReusableCollectionDataSource.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/15/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

open class ReusableCollectionDataSource<Provider: DataProvider, Cell: UICollectionViewCell & ConfigurableCell> : NSObject, UICollectionViewDataSource, ReusableSource where Provider.T == Cell.T {
    
    public let provider: Provider
    public let collectionView: UICollectionView
    
    public required init(provider: Provider, collectionView: UICollectionView) {
        self.provider = provider
        self.collectionView = collectionView
        super.init()
        setup()
    }
    
    public func setup() {
        collectionView.dataSource = self
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return provider.numberOfSections()
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provider.numberOfItems(in: section)
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        let item = provider.item(at: indexPath)
        if let item = item {
            cell.configure(item, at: indexPath)
            configureBehavior(for: cell, at: indexPath)
        }
        return cell
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
    
    public func loadItems(payload: Provider.V) {
        provider.loadItems(payload: payload)
    }
    
    open func resetValues() {
        provider.resetValues()
    }
    
    open func configureBehavior(for cell: Cell, at indexPath: IndexPath) {
        //Override and implement
        return
    }
}
