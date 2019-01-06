//
//  SingleSectionDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/18/18.
//

/// A DataProvider implementation to provide data for a single section with
/// an associated model
open class SingleSectionDataProvider<T>: DataProvider {
    
    /// The data management structure for the DataProvider must be an
    /// Array<T>
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
