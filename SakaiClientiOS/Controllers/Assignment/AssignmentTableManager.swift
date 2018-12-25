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

    var textViewDelegate = Delegated<Void, UITextViewDelegate>()
    var selectedAssignmentAt = Delegated<(IndexPath, Int), Void>()

    private var selectedRow: Int?

    var selectedAssignmentCell: AssignmentCell?
    var selectedAssignmentCellFrame: CGRect?

    var selectedCell: AssignmentTableCell?
    
    convenience init(tableView: UITableView) {
        self.init(provider: AssignmentTableDataProvider(), fetcher: AssignmentDataFetcher(), tableView: tableView)
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
        
        cell.manager.selectedAt.delegate(to: self) { (self, cellIndexPath) -> Void in
            // keep track of selected index within collectionView
            self.selectedAssignmentCell = cell.collectionView.cellForItem(at: cellIndexPath) as? AssignmentCell
            self.selectedAssignmentCellFrame = self.selectedAssignmentCell?.frame
            self.selectedCell = cell
            self.selectedAssignmentAt.call((indexPath, cellIndexPath.row))
        }
        cell.manager.textViewDelegate.delegate(to: self) { (self, voidInput) -> UITextViewDelegate? in
            return self.textViewDelegate.call()
        }
    }
    
    func resetSort() {
        provider.toggleDateSorted(to: false)
    }
    
    /// Switch data grouping between class and Term
    func switchSort() {
        provider.toggleDateSorted(to: !provider.dateSorted)
        reloadData()
    }

    func toggleSite(at indexPath: IndexPath) {
        provider.toggleCollapsed(at: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        if provider.isCollapsed(at: indexPath) {
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        } else {
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
}

extension AssignmentTableManager: PageDelegate {
    func pageController(_ pageController: PagesController, didMoveToIndex index: Int) {
        selectedAssignmentCell?.flip(animated: false) {}
        selectedAssignmentCell = nil
        let indexPath = IndexPath(row: index, section: 0)
        selectedCell?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        let attributes = selectedCell?.collectionView.layoutAttributesForItem(at: indexPath)
        selectedAssignmentCellFrame = attributes?.frame
        selectedRow = index
        selectedCell?.manager.flipForTransitionIndex = index
    }

    func flipIfNecessary() {
        if selectedAssignmentCell != nil {
            selectedAssignmentCell?.flip {}
            setSelectionsToNil()
            return
        }
        guard
            let index = selectedRow,
            let cell = selectedCell?.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? AssignmentCell
        else {
            setSelectionsToNil()
            return
        }

        cell.flip(withDirection: .toFront, animated: true) {}
        setSelectionsToNil()
    }

    func setSelectionsToNil() {
        selectedAssignmentCell = nil
        selectedCell = nil
        selectedRow = nil
    }
}
