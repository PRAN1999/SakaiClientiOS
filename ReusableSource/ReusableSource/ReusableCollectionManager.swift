//
//  ReusableCollectionDataSourceDelegate.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/15/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import UIKit

/// Subclass ReusableCollectionDataSource to add UICollectionViewDelegate conformance for added flexibility managing collectionView
open class ReusableCollectionManager<Provider: DataProvider, Cell: UICollectionViewCell & ConfigurableCell> : ReusableCollectionDataSource<Provider, Cell>, UICollectionViewDelegateFlowLayout where Provider.T == Cell.T {
    
    public var selectedAt = Delegated<IndexPath, Void>()
    
    /// Assign dataSource and delegate of collectionView to and register Cell.self with collectionView
    open override func setup() {
        super.setup()
        collectionView.delegate = self
    }
    
    // MARK: Delegate methods implemented here because subclasses cannot provide protocol method implementation, so they must be overridden
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAt.call(indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
}
