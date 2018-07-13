//
//  ReusableTableController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import UIKit

open class ReusableTableSource<Provider:DataProvider, Cell:UITableViewCell, Fetcher: DataFetcher>: NSObject, UITableViewDataSource, UITableViewDelegate where Cell: ConfigurableCell, Provider.T == Cell.T, Provider.V == Fetcher.T {
    
    let provider: Provider
    let fetcher: Fetcher
    let tableView: UITableView
    
    init(provider: Provider, fetcher: Fetcher, tableView: UITableView) {
        self.provider = provider
        self.tableView = tableView
        self.fetcher = fetcher
        super.init()
        setup()
    }
    
    func setup() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return provider.numberOfSections()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Section: \(section), Rows: \(provider.numberOfItems(in: section))")
        return provider.numberOfItems(in: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        let item = provider.item(at: indexPath)
        if let item = item {
            cell.configure(item, at: indexPath)
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Override and implement
        return nil
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Override and implement
        return
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //Override and implement
        return 0
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Override and implement
        return
    }
    
    public func item(at indexPath: IndexPath) -> Provider.T? {
        return provider.item(at: indexPath)
    }
    
    public func loadDataSource(completion: @escaping () -> Void) {
        provider.resetValues()
        self.tableView.reloadData()
        fetcher.loadData { (res) in
            guard let response = res else {
                completion()
                return
            }
            self.provider.loadItems(payload: response)
            self.tableView.reloadData()
            completion()
        }
    }
    
    public func loadDataSourceWithoutCache(completion: @escaping () -> Void) {
        provider.resetValues()
        self.tableView.reloadData()
        fetcher.loadDataWithoutCache { (res) in
            guard let response = res else {
                completion()
                return
            }
            self.provider.loadItems(payload: response)
            self.tableView.reloadData()
            completion()
        }
    }
}
