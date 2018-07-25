//
//  ReusableCollectionDataSourceDelegate.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/15/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import UIKit

open class ReusableCollectionDataSourceFlowDelegate<Provider: DataProvider, Cell: UICollectionViewCell & ConfigurableCell> : ReusableCollectionDataSource<Provider, Cell>, UICollectionViewDelegateFlowLayout where Provider.T == Cell.T {
    
    open override func setup() {
        super.setup()
        collectionView.delegate = self
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Override and implement
        return
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
}
