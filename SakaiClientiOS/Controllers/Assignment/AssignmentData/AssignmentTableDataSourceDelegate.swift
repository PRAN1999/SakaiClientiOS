//
//  AssignmentTableSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/14/18.
//

import ReusableSource

class AssignmentTableDataSourceDelegate: HideableTableDataSourceDelegate<AssignmentTableDataProvider, AssignmentTableCell>, NetworkSource {
    
    typealias Fetcher = AssignmentDataFetcher
    
    var fetcher: AssignmentDataFetcher
    var controller: AssignmentController?
    
    override init(provider: AssignmentTableDataProvider, tableView: UITableView) {
        fetcher = AssignmentDataFetcher()
        super.init(provider: provider, tableView: tableView)
    }
    
    convenience init(tableView: UITableView) {
        self.init(provider: AssignmentTableDataProvider(), tableView: tableView)
    }
    
    override func configureBehavior(for cell: AssignmentTableCell, at indexPath: IndexPath) {
        cell.dataSourceDelegate.controller = controller
    }
    
    func resetSort() {
        provider.dateSorted = false
    }
    
    func switchSort() {
        provider.dateSorted = !provider.dateSorted
        reloadData()
    }
}
