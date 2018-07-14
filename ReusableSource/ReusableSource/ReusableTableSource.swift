//
//  ReusableTableSource.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/14/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

open class ReusableTableSource<Provider:DataProvider, Cell:UITableViewCell & ConfigurableCell>: NSObject, UITableViewDataSource, UITableViewDelegate, ReusableSource where Provider.T == Cell.T {
    public let provider: Provider
    public let tableView: UITableView
    
    public required init(provider: Provider, tableView: UITableView) {
        self.provider = provider
        self.tableView = tableView
        super.init()
        setup()
    }
    
    public func setup() {
        tableView.dataSource = self
        tableView.delegate = self
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
        }
        return cell
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Override and implement
        return nil
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Override and implement
        return
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //Override and implement
        return 0
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Override and implement
        return
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
}
