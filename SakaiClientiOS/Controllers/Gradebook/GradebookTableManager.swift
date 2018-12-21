//
//  GradebookTableManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/12/18.
//

import UIKit
import ReusableSource

/// An abstraction to manage the data source and delegate for the Gradebook tab. Divides grades
/// by Term and further subdivides by class
class GradebookTableManager: HideableNetworkTableManager<GradebookDataProvider, GradebookCell, GradebookDataFetcher> {
    
    private let headerCell = FloatingHeaderCell()
    private var headerClass: (Int, Int)?

    convenience init(tableView: UITableView) {
        self.init(provider: GradebookDataProvider(), fetcher: GradebookDataFetcher(), tableView: tableView)
    }
    
    override func setup() {
        super.setup()
        tableView.register(SiteCell.self, forCellReuseIdentifier: SiteCell.reuseIdentifier)
        selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            self.tableView.deselectRow(at: indexPath, animated: true)
            let subsectionPath = self.provider.getSubsectionIndexPath(section: indexPath.section, row: indexPath.row)
            if subsectionPath.row == 0 {
                self.toggleClass(at: subsectionPath.section, in: indexPath.section)
            }
        }
        headerCell.tapRecognizer.delegate = self
        headerCell.tapRecognizer.addTarget(self, action: #selector(toggleCurrentClass(sender:)))
        tableView.showsVerticalScrollIndicator = false
        tableView.addSubview(headerCell)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if provider.isEmpty(section: indexPath.section) {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        let subsectionIndex = provider.getSubsectionIndexPath(section: indexPath.section, row: indexPath.row)

        // If the subsection index is 0, the cell is a class header. Otherwise, it is a regular
        // grade item
        if subsectionIndex.row == 0 {
            return getSiteTitleCell(tableView: tableView, indexPath: indexPath, subsection: subsectionIndex.section)
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Construct a sticky header to display which class's grades are currently being scrolled
        let point = CGPoint(x: 0, y: tableView.contentOffset.y)
        guard let topIndex = tableView.indexPathForRow(at: point) else {
            hideHeaderCell()
            return
        }
        if provider.isEmpty(section: topIndex.section) {
            hideHeaderCell()
            return
        }
        let subsectionIndex = provider.getSubsectionIndexPath(section: topIndex.section, row: topIndex.row)
        let headerRow = provider.getHeaderRowForSubsection(section: topIndex.section, subsection: subsectionIndex.section)
        let cell = tableView.cellForRow(at: IndexPath(row: headerRow, section: topIndex.section))
        
        if(cell != nil && (cell?.frame.minY)! > tableView.contentOffset.y ) {
            hideHeaderCell()
        } else {
            makeHeaderCellVisible(section: topIndex.section, subsection: subsectionIndex.section)
        }
    }

    func hideHeaderCell() {
        headerCell.isHidden = true
        headerClass = nil
    }

    /// Construct a class title cell to separate classes within a Term section using the given subsection
    ///
    /// - Parameters:
    ///   - tableView: the tableView being constructed
    ///   - indexPath: the "true" indexPath of the cell
    ///   - subsection: the location of the data as managed by the GradebookDataProvider
    /// - Returns: a cell containing a class title
    private func getSiteTitleCell(tableView: UITableView, indexPath: IndexPath, subsection: Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SiteCell.reuseIdentifier, for: indexPath) as? SiteCell else {
            fatalError("Not a site cell")
        }

        cell.accessoryType = .none
        cell.titleLabel.text = provider.getSubsectionTitle(section: indexPath.section, subsection: subsection)
        cell.titleLabel.textColor = UIColor.white
        cell.backgroundColor = UIColor.black

        return cell
    }
    
    private func makeHeaderCellVisible(section: Int, subsection: Int) {
        let headerHeight = super.tableView(tableView, heightForHeaderInSection: section)
        let frame = CGRect(x: 0, y: tableView.contentOffset.y + headerHeight, width: tableView.frame.size.width, height: headerCell.frame.size.height)
        let title =  provider.getSubsectionTitle(section: section, subsection: subsection)
        
        headerCell.setTitle(title: title)
        headerCell.setFrameAndMakeVisible(frame: frame)
        tableView.bringSubview(toFront: headerCell)
        headerClass = (section, subsection)
    }

    @objc private func toggleCurrentClass(sender: UITapGestureRecognizer) {
        guard let (section, subsection) = headerClass else {
            return
        }
        toggleClass(at: subsection, in: section)
    }

    private func toggleClass(at subsection: Int, in section: Int) {
        
    }
}
