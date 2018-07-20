//
//  FeedDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/18/18.
//

import ReusableSource

class SingleSectionDataProvider<T>: DataProvider {
    typealias V = [T]
    
    var items: V = []
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return items.count
    }
    
    func item(at indexPath: IndexPath) -> T? {
        return items[indexPath.row]
    }
    
    func resetValues() {
        items = []
    }
    
    func loadItems(payload: [T]) {
        items = payload
    }
}
