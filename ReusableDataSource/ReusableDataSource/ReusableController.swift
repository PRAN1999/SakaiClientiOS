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
    var tableSource: ReusableTableSource<Provider, Cell, Fetcher> { get }
}

public extension ReusableController where Self:UIViewController {
    func loadTableSource() {
        let indicator = constructIndicator()
        view.addSubview(indicator)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        tableSource.loadDataSourceWithoutCache {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            print("Loaded")
        }
    }
    
    func constructIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        indicator.center = CGPoint(x: view.center.x, y: view.center.y - 80)
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.color = UIColor.black
        indicator.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        return indicator
    }
}
