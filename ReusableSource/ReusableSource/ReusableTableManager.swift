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
open class ReusableTableManager<
    Provider: DataProvider, Cell: UITableViewCell & ConfigurableCell>
    : ReusableTableDataSource<Provider, Cell>, UITableViewDelegate
    where Provider.T == Cell.T {
    
    public var selectedAt = Delegated<IndexPath, Void>()

    public let emptyView: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Looks like there's nothing here..."
        return label
    }()
    open var emptyViewHeight: CGFloat {
        return 75
    }
    
    /// Assign dataSource and delegate of tableView to and register
    /// Cell.self with tableView
    open override func setup() {
        super.setup()
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }

    open override func numberOfSections(in tableView: UITableView) -> Int {
        return provider.numberOfSections()
    }

    open override func reloadDataWithEmptyCheck() {
        reloadData()
        if isEmpty() {
            emptyView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: emptyViewHeight)
            tableView.addSubview(emptyView)
            tableView.tableHeaderView = emptyView
        } else {
            emptyView.removeFromSuperview()
            var frame = CGRect.zero
            frame.size.height = .leastNormalMagnitude
            tableView.tableHeaderView = UIView(frame: frame)
        }
    }
    
    // MARK: Delegate methods implemented here because subclasses cannot
    // provide protocol method implementation, so they must be overridden
    
    open func tableView(_ tableView: UITableView,
                        viewForHeaderInSection section: Int) -> UIView? {
        //Override and implement
        return nil
    }
    
    open func tableView(_ tableView: UITableView,
                        didSelectRowAt indexPath: IndexPath) {
        selectedAt.call(indexPath)
    }
    
    open func tableView(_ tableView: UITableView,
                        heightForHeaderInSection section: Int) -> CGFloat {
        //Override and implement
        return 0
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Override and implement
        return
    }
}
