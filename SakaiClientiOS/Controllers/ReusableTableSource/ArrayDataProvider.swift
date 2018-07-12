//
//  ArrayDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import UIKit

public class ArrayDataProvider<T>: DataProvider {
    // MARK: - Internal Properties
    public typealias V = [[T]]
    var items: V = []
    
    // MARK: - DataProvider
    public func numberOfSections() -> Int {
        return items.count
    }
    
    public func numberOfItems(in section: Int) -> Int {
        guard section >= 0 && section < items.count else {
            return 0
        }
        return items[section].count
    }
    
    public func item(at indexPath: IndexPath) -> T? {
        guard indexPath.section >= 0 && indexPath.section < items.count &&
            indexPath.row >= 0 && indexPath.row < items[indexPath.section].count else {
                return nil
        }
        return items[indexPath.section][indexPath.row]
    }
    
    public func resetValues() {
        items = []
    }
    
    public func loadItems(payload: V) {
        items = payload
    }
}
