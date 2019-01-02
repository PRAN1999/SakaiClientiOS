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

    var selectedAssignmentAt = Delegated<(IndexPath, Int), Void>()
    weak var textViewDelegate: UITextViewDelegate?

    private(set) var selectedManager: AssignmentCollectionManager?
    private var oldIndexPath: IndexPath?
    
    convenience init(tableView: UITableView) {
        self.init(provider: AssignmentTableDataProvider(termService: SakaiService.shared),
                  fetcher: AssignmentDataFetcher(termService: SakaiService.shared,
                                                 networkService: RequestManager.shared),
                  tableView: tableView)
    }
    
    override func setup() {
        super.setup()
        tableView.register(AssignmentTitleCell.self, forCellReuseIdentifier: AssignmentTitleCell.reuseIdentifier)
        tableView.allowsSelection = true
        tableView.sectionHeaderHeight = 0.0;
        tableView.sectionFooterHeight = 0.0;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if provider.isCollapsed(at: indexPath) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AssignmentTitleCell.reuseIdentifier, for: indexPath) as? AssignmentTitleCell else {
                fatalError("Cannot dequeue cell")
            }
            if let item = provider.item(at: indexPath) {
                cell.configure(item, at: indexPath)
            }
            if provider.dateSorted {
                cell.titleLabel.titleLabel.text = "All Assignments"
            }
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func configureBehavior(for cell: AssignmentTableCell, at indexPath: IndexPath) {
        if provider.dateSorted {
            cell.titleLabel.titleLabel.text = "All Assignments"
        }

        selectedManager = cell.manager
        
        cell.manager.selectedAt.delegate(to: self) { (self, cellIndexPath) -> Void in
            self.selectedAssignmentAt.call((indexPath, cellIndexPath.row))
        }
        cell.manager.textViewDelegate = textViewDelegate
    }
    
    func reset() {
        oldIndexPath = nil
        provider.toggleDateSorted(to: false)
    }
    
    /// Switch data grouping between class and Term
    func switchSort() {
        if let old = oldIndexPath {
            provider.toggleCollapsed(at: old)
            oldIndexPath = nil
        }
        provider.toggleDateSorted(to: !provider.dateSorted)
        reloadData()
    }

    func toggleSite(at indexPath: IndexPath) {
        var arr: [IndexPath] = [indexPath]
        if let old = oldIndexPath {
            if old == indexPath {
                oldIndexPath = nil
            } else {
                provider.toggleCollapsed(at: old)
                oldIndexPath = indexPath
                if !provider.isHidden(section: old.section) {
                    arr.append(old)
                }
            }
        } else {
            oldIndexPath = indexPath
        }
        provider.toggleCollapsed(at: indexPath)
        tableView.reloadRows(at: arr, with: .automatic)
        if provider.isCollapsed(at: indexPath) {
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        } else {
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
}
