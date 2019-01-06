//
//  GradebookTableManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/12/18.
//

import UIKit
import ReusableSource

/// An abstraction to manage the data source and delegate for the Gradebook tab.
/// Divides grades by Term and further subdivides by class
class GradebookTableManager: HideableNetworkTableManager<GradebookDataProvider, GradebookCell, GradebookDataFetcher> {

    private enum Direction {
        case up, down
    }
    
    private let headerCell = GradebookHeaderCell()
    private var previousHeaderHeight: CGFloat = 44.0
    private var lastContentOffset: CGFloat = 0.0
    private var headerClass: (Int, Int)?
    private var scrollUpOnLastRow = false

    convenience init(tableView: UITableView) {
        self.init(provider: GradebookDataProvider(termService: SakaiService.shared),
                  fetcher: GradebookDataFetcher(termService: SakaiService.shared,
                                                networkService: RequestManager.shared),
                  tableView: tableView)
    }
    
    override func setup() {
        super.setup()
        tableView.register(GradebookHeaderCell.self,
                           forCellReuseIdentifier: GradebookHeaderCell.reuseIdentifier)
        tableView.sectionHeaderHeight = 0.0;
        tableView.sectionFooterHeight = 0.0;
        selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            self.tableView.deselectRow(at: indexPath, animated: true)
            if self.provider.isEmpty(section: indexPath.section) {
                return
            }
            let subsectionPath = self.provider.getSubsectionIndexPath(section: indexPath.section,
                                                                      row: indexPath.row)
            if subsectionPath.row == 0 {
                self.toggleClass(at: subsectionPath.section, in: indexPath.section)
            }
        }
        headerCell.tapRecognizer.delegate = self
        headerCell.tapRecognizer.addTarget(self, action: #selector(toggleCurrentClass(sender:)))
        tableView.backgroundColor = Palette.main.primaryBackgroundColor
        tableView.separatorColor = Palette.main.tableViewSeparatorColor
        tableView.indicatorStyle = Palette.main.scrollViewIndicatorStyle
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

    override func reloadData(for section: Int) {
        super.reloadData(for: section)
        scrollViewDidScroll(tableView)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var direction: Direction = .up

        if scrollView.contentOffset.y > lastContentOffset {
            direction = .down
        }
        lastContentOffset = scrollView.contentOffset.y

        var subtractedHeaderHeight = false

        var yVal = tableView.contentOffset.y + previousHeaderHeight
        if direction == .up && (headerCell.isHidden || scrollUpOnLastRow) {
            subtractedHeaderHeight = true
            yVal -= previousHeaderHeight
        }
        if direction == .down {
            yVal = tableView.contentOffset.y + headerCell.bounds.height
        }
        let point = CGPoint(x: 0, y: yVal)
        
        guard let topIndex = tableView.indexPathForRow(at: point) else {
            return
        }

        let subsectionIndex = provider.getSubsectionIndexPath(section: topIndex.section,
                                                              row: topIndex.row)
        let headerRow = provider.getHeaderRowForSubsection(section: topIndex.section,
                                                           subsection: subsectionIndex.section)
        let cell = tableView.cellForRow(at: IndexPath(row: headerRow,
                                                      section: topIndex.section))

        if direction == .up && provider.getCount(for: topIndex.section) - 1 == topIndex.row && subtractedHeaderHeight {
            guard let lastCell = tableView.cellForRow(at: topIndex) else {
                return
            }
            let y = lastCell.frame.maxY - headerCell.bounds.height
            let frame = CGRect(x: 0,
                               y: y,
                               width: tableView.frame.size.width,
                               height: headerCell.frame.size.height)

            makeHeaderCellVisible(in: topIndex.section,
                                  for: subsectionIndex.section,
                                  at: frame)
            scrollUpOnLastRow = true
            return
        } else if headerRow == topIndex.row {
            guard let cell = cell else {
                return
            }
            previousHeaderHeight = cell.bounds.height
            if direction == .up {
                guard subsectionIndex.section > 0 else {
                    hideHeaderCell()
                    return
                }
                let y = cell.frame.minY - headerCell.bounds.height
                let frame = CGRect(x: 0,
                                   y: y,
                                   width: tableView.frame.size.width,
                                   height: headerCell.frame.size.height)
                makeHeaderCellVisible(in: topIndex.section, for: subsectionIndex.section - 1, at: frame)
            }
            scrollUpOnLastRow = false
            return
        }

        scrollUpOnLastRow = false
        if cell != nil && (cell?.frame.minY)! > yVal {
            hideHeaderCell()
        } else {
            let frame = CGRect(x: 0,
                               y: tableView.contentOffset.y,
                               width: tableView.frame.size.width,
                               height: headerCell.frame.size.height)
            makeHeaderCellVisible(in: topIndex.section, for: subsectionIndex.section, at: frame)
        }
    }

    func hideHeaderCell() {
        headerCell.isHidden = true
        headerClass = nil
    }

    private func getSiteTitleCell(tableView: UITableView, indexPath: IndexPath, subsection: Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GradebookHeaderCell.reuseIdentifier, for: indexPath) as? GradebookHeaderCell else {
            fatalError("Not a site cell")
        }

        let title = provider.getSubsectionTitle(section: indexPath.section, subsection: subsection)
        let code = provider.getSubjectCode(section: indexPath.section, subsection: subsection)
        cell.configure(title: title, subjectCode: code)
        cell.tapRecognizer.isEnabled = false
        
        return cell
    }
    
    private func makeHeaderCellVisible(in section: Int, for subsection: Int, at frame: CGRect) {
        let title = provider.getSubsectionTitle(section: section, subsection: subsection)
        let code = provider.getSubjectCode(section: section, subsection: subsection)
        headerCell.configure(title: title, subjectCode: code)
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
        provider.toggleCollapsed(section: section, subsection: subsection)
        let indexPaths = provider.indexPaths(section: section, subsection: subsection)
        tableView.beginUpdates()
        if provider.isCollapsed(section: section, subsection: subsection) {
            tableView.deleteRows(at: indexPaths, with: .automatic)
        } else {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
        tableView.endUpdates()
        let row = provider.getHeaderRowForSubsection(section: section, subsection: subsection)
        let indexPath = IndexPath(row: row, section: section)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}
