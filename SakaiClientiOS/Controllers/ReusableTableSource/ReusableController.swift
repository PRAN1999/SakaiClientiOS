//
//  ReusableController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/12/18.
//

import UIKit

protocol ReusableController {
    associatedtype Provider: DataProvider
    associatedtype Cell: UITableViewCell, ConfigurableCell where Provider.T == Cell.T
    associatedtype Fetcher: DataFetcher where Provider.V == Fetcher.T
    var tableSource: ReusableTableSource<Provider, Cell, Fetcher> { get }
}

extension ReusableController where Self:UIViewController {
    func loadTableSource() {
        let indicator = LoadingIndicator(view: view)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        tableSource.loadDataSourceWithoutCache {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            print("Loaded")
        }
    }
}
