//
//  ReusableController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/12/18.
//

import UIKit

public protocol ReusableController {
    associatedtype Provider: DataProvider
    associatedtype Cell: UITableViewCell, ConfigurableCell where Provider.T == Cell.T
    associatedtype Fetcher: DataFetcher where Provider.V == Fetcher.T
    var reusableSource: ReusableTableSource<Provider, Cell, Fetcher> { get }
}
