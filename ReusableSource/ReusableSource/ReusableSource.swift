//
//  ReusableSource.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/14/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

public protocol ReusableSource {
    associatedtype Cell: ReusableCell
    associatedtype Provider: DataProvider
    
    var provider: Provider { get }
    
    func resetValues()
    func reloadData()
    func loadItems(payload: Provider.V)
    
    func configureBehavior(for cell: Cell, at indexPath: IndexPath)
}
