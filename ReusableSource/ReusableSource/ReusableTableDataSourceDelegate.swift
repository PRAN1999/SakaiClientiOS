//
//  ReusableTableDataSourceDelegate.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/14/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

open class ReusableTableDataSourceDelegate<Provider:DataProvider, Cell:UITableViewCell & ConfigurableCell>: ReusableTableDataSource<Provider, Cell>, UITableViewDelegate where Provider.T == Cell.T {
    
    open override func setup() {
        super.setup()
        tableView.delegate = self
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
}
