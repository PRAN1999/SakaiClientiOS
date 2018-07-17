//
//  DataProvider.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/11/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

public protocol DataProvider {
    associatedtype T
    associatedtype V
    
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> T?
    
    func resetValues()
    func loadItems(payload: V)
}
