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
class GradebookTableManager : HideableNetworkTableManager<GradebookDataProvider, GradebookCell, GradebookDataFetcher> {
    
    private let headerCell = FloatingHeaderCell()

    override init(provider: Provider, fetcher: Fetcher, tableView: UITableView) {
        super.init(provider: provider, fetcher: fetcher, tableView: tableView)
    }

    convenience init(tableView: UITableView) {
        self.init(provider: GradebookDataProvider(), fetcher: GradebookDataFetcher(), tableView: tableView)
    }
    
    override func setup() {
        super.setup()
        tableView.register(SiteCell.self, forCellReuseIdentifier: SiteCell.reuseIdentifier)
        tableView.allowsSelection = false
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
    
    /// Construct a class title cell to separate classes within a Term section using the given subsection
    ///
    /// - Parameters:
    ///   - tableView: the tableView being constructed
    ///   - indexPath: the "true" indexPath of the cell
    ///   - subsection: the location of the data as managed by the GradebookDataProvider
    /// - Returns: a cell containing a class title
    func getSiteTitleCell(tableView: UITableView, indexPath: IndexPath, subsection:Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SiteCell.reuseIdentifier, for: indexPath) as? SiteCell else {
            fatalError("Not a site cell")
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.none
        cell.titleLabel.text = provider.getSubsectionTitle(section: indexPath.section, subsection: subsection)
        cell.titleLabel.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
        
        return cell
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
        let headerRow = provider.getHeaderRowForSubsection(section: topIndex.section, indexPath: subsectionIndex)
        let cell = tableView.cellForRow(at: IndexPath(row: headerRow, section: topIndex.section))
        
        if(cell != nil && (cell?.frame.minY)! > tableView.contentOffset.y ) {
            hideHeaderCell()
        } else {
            makeHeaderCellVisible(section: topIndex.section, subsection: subsectionIndex.section)
        }
    }
    
    func makeHeaderCellVisible(section: Int, subsection: Int) {
        let frame = CGRect(x: 0, y: tableView.contentOffset.y, width: tableView.frame.size.width, height: headerCell.frame.size.height)
        let title =  provider.getSubsectionTitle(section: section, subsection: subsection)
        
        headerCell.setTitle(title: title)
        headerCell.setFrameAndMakeVisible(frame: frame)
        tableView.bringSubview(toFront: headerCell)
    }
    
    func hideHeaderCell() {
        headerCell.isHidden = true
    }
}
