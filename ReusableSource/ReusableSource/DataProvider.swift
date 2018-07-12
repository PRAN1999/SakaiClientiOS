//
//  DataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
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
