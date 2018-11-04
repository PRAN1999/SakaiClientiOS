//
//  AssignmentTableManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/14/18.
//

import ReusableSource

/// A data source and delegate for the Assignments tab
///
/// The AssignmentTableManager controls the Assignments for different classes and different Terms.
/// Whether split by class or term, each cell in the tableView will contain a collection of classes
/// associated with that class or Term.
///
/// So, while selecting the tableView cell will do nothing, the
/// AssignmentTableManager handles the selection of any Assignment in the collectionView within any cell
class AssignmentTableManager: HideableNetworkTableManager<AssignmentTableDataProvider, AssignmentTableCell, AssignmentDataFetcher> {
    
    var lastSelectedIndex: Int?
    
    var textViewDelegate = Delegated<Void, UITextViewDelegate>()
    
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
        cell.manager.selectedAt.delegate(to: self) { (self, cellIndexPath) -> Void in
            // keep track of selected index within collectionView
            self.lastSelectedIndex = cellIndexPath.row
            self.selectedAt.call(indexPath)
        }
        cell.manager.textViewDelegate.delegate(to: self) { (self, voidInput) -> UITextViewDelegate? in
            return self.textViewDelegate.call()
        }
    }
    
    func resetSort() {
        provider.dateSorted = false
    }
    
    /// Switch data grouping between class and Term
    func switchSort() {
        provider.dateSorted = !provider.dateSorted
        reloadData()
    }
}
