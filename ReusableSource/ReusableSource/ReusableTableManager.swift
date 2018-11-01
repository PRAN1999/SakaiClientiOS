//
//  ReusableTableManager.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/14/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

/// Subclass ReusableTableDataSource to add UITableViewDelegate conformance
/// for added flexibility managing tableView
open class ReusableTableManager<Provider: DataProvider, Cell: UITableViewCell & ConfigurableCell>: ReusableTableDataSource<Provider, Cell>, UITableViewDelegate where Provider.T == Cell.T {
    
    public var selectedAt = Delegated<IndexPath, Void>()
    
    /// Assign dataSource and delegate of tableView to and register Cell.self with tableView
    open override func setup() {
        super.setup()
        tableView.delegate = self
    }
    
    // MARK: Delegate methods implemented here because subclasses cannot provide protocol method implementation, so they must be overridden
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Override and implement
        return nil
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAt.call(indexPath)
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //Override and implement
        return 0
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Override and implement
        return
    }
}
