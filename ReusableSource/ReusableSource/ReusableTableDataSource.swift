//
//  ReusableTableDataSource.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/15/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

/// A generic implementation for a UITableViewDataSource with a
/// DataProvider and ConfigurableCell where the Provider and Cell deal with
/// the same associated model
open class ReusableTableDataSource
    <Provider: DataProvider, Cell: UITableViewCell & ConfigurableCell>
    : NSObject, UITableViewDataSource, ReusableSource
    where Provider.T == Cell.T {

    public let provider: Provider
    public let tableView: UITableView
    
    /// Initialize the DataSource and setup the managed UITableView
    ///
    /// - Parameters:
    ///   - provider: A Provider object to populate the DataSource
    ///   - tableView: The UITableView to manage within the data source
    public init(provider: Provider, tableView: UITableView) {
        self.provider = provider
        self.tableView = tableView
        super.init()
        setup()
    }
    
    /// Assign the tableView dataSource and register the associated Cell
    /// class with the tableView
    open func setup() {
        tableView.dataSource = self
        
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return provider.numberOfSections()
    }
    
    open func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
        return provider.numberOfItems(in: section)
    }
    
    /// Provide a default implementation for returning and configuring a
    /// UITableViewCell making use of DataProvider and ConfigurableCell
    /// methods
    open func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier,
                                                       for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        let item = provider.item(at: indexPath)
        if let item = item {
            cell.configure(item, at: indexPath)
            configureBehavior(for: cell, at: indexPath)
        }
        return cell
    }
    
    open func item(at indexPath: IndexPath) -> Provider.T? {
        return provider.item(at: indexPath)
    }
    
    open func reloadData() {
        tableView.reloadData()
    }

    open func reloadDataWithEmptyCheck() {
        reloadData()
    }
    
    open func reloadData(for section: Int) {
        tableView.reloadSections([section], with: .automatic)
    }
    
    open func loadItems(payload: Provider.V) {
        provider.loadItems(payload: payload)
    }
    
    open func resetValues() {
        provider.resetValues()
    }
    
    open func configureBehavior(for cell: Cell, at indexPath: IndexPath) {
        //Override and implement
        return
    }

    open func isEmpty() -> Bool {
        return provider.numberOfSections() == 0
    }
}
