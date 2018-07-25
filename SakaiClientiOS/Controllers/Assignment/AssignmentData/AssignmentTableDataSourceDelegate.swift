//
//  AssignmentTableSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/14/18.
//

import ReusableSource

class AssignmentTableDataSourceDelegate: HideableNetworkTableDataSourceDelegate<AssignmentTableDataProvider, AssignmentTableCell, AssignmentDataFetcher> {
    var controller: AssignmentController?
    
    init(tableView: UITableView) {
        super.init(provider: AssignmentTableDataProvider(), fetcher: AssignmentDataFetcher(), tableView: tableView)
    }
    
    override func setup() {
        super.setup()
        tableView.allowsSelection = false
    }
    
    override func configureBehavior(for cell: AssignmentTableCell, at indexPath: IndexPath) {
        if provider.dateSorted {
            cell.titleLabel.text = "All Assignments"
        }
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
