//
//  ConfigurableCell.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/11/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

/// A protocol for any UITableViewCell or UICollectionViewCell subclass
/// to configure its views according to a model object at an indexPath
public protocol ConfigurableCell: ReusableCell {
    
    /// The specified model type for the cell to configure itself with
    associatedtype T
    
    /// Configure the cell accordingly based on the model associated with
    /// the specified indexPath
    ///
    /// - Parameters:
    ///   - item: The model object to configure the cell with. It will be
    ///           of type T, specific to each ConfigurableCell
    ///   - indexPath: The IndexPath at which this cell will be displayed
    ///                in a UITableView or UICollectionView
    func configure(_ item: T, at indexPath: IndexPath)
}
