//
//  ReusableTableDataSource.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/15/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

open class ReusableTableDataSource<Provider:DataProvider, Cell:UITableViewCell & ConfigurableCell>: NSObject, UITableViewDataSource, ReusableSource where Provider.T == Cell.T {
    
    public let provider: Provider
    public let tableView: UITableView
    
    public init(provider: Provider, tableView: UITableView) {
        self.provider = provider
        self.tableView = tableView
        super.init()
        setup()
    }
    
    public func setup() {
        tableView.dataSource = self
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return provider.numberOfSections()
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Section: \(section), Rows: \(provider.numberOfItems(in: section))")
        return provider.numberOfItems(in: section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
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
    
    public func reloadData() {
        tableView.reloadData()
    }
    
    public func loadItems(payload: Provider.V) {
        provider.loadItems(payload: payload)
    }
    
    open func resetValues() {
        provider.resetValues()
    }
    
    open func configureBehavior(for cell: Cell, at indexPath: IndexPath) {
        //Override and implement
        return
    }
}
