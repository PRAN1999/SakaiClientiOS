//
//  FeedDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/18/18.
//

open class SingleSectionDataProvider<T>: DataProvider {
    public typealias V = [T]
    
    public var items: V = []
    
    public init() {}
    
    public func numberOfSections() -> Int {
        return 1
    }
    
    open func numberOfItems(in section: Int) -> Int {
        return items.count
    }
    
    open func item(at indexPath: IndexPath) -> T? {
        return items[indexPath.row]
    }
    
    open func resetValues() {
        items = []
    }
    
    open func loadItems(payload: [T]) {
        items = payload
    }
}
