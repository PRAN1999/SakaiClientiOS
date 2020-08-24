//
//  GradebookTableManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/12/18.
//

import UIKit
import ReusableSource

/// An abstraction to manage the data source and delegate for the Gradebook
/// tab. Divides grades by Term and further subdivides by class. Also
/// manages sticky header for site context while scrolling grades
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
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            self.tableView.deselectRow(at: indexPath, animated: true)
            if self.provider.isEmpty(section: indexPath.section) {
                return
            }
            let subsectionPath = self.provider.getSubsectionIndexPath(section: indexPath.section,
                                                                      row: indexPath.row)
            if subsectionPath.row == 0 {
                // If a subsection header is selected, the subsection should
                // be toggled
                self.toggleClass(at: subsectionPath.section, in: indexPath.section)
            }
        }
        // Since selecting the header cell will not register as a tableview
        // selection, the tap recognizer in the cell must be configured to
        // trigger a toggle
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

        // If the subsection index is 0, the cell is a class header.
        // Otherwise, it is a regular grade item
        if subsectionIndex.row == 0 {
            return getSiteTitleCell(tableView: tableView, indexPath: indexPath, subsection: subsectionIndex.section)
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }

    override func reloadData(for section: Int) {
        super.reloadData(for: section)
        scrollViewDidScroll(tableView)
        if headerCell.frame.minY > tableView.contentOffset.y {
            hideHeaderCell()
        }
    }

    // swiftlint:disable cyclomatic_complexity function_body_length
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var direction: Direction = .up

        if scrollView.contentOffset.y > lastContentOffset {
            direction = .down
        }
        lastContentOffset = scrollView.contentOffset.y

        var subtractedHeaderHeight = false

        var yVal = tableView.contentOffset.y + previousHeaderHeight
        if direction == .up && (headerCell.isHidden || scrollUpOnLastRow) {
            // If the scrollView is scrolling up on the last row in a
            // section or the header cell is already hidden, the size
            // of the header cell should not be considered in determining
            // the new frame of the header cell.
            subtractedHeaderHeight = true
            yVal -= previousHeaderHeight
        }
        if direction == .down {
            yVal = tableView.contentOffset.y + headerCell.bounds.height
        }
        let point = CGPoint(x: 0, y: yVal)

        // Retrieve the indexPath at the calculated point in order to
        // determine where to place the header cell as the user scrolls
        guard let topIndex = tableView.indexPathForRow(at: point) else {
            hideHeaderCell()
            return
        }

        let subsectionIndex = provider.getSubsectionIndexPath(section: topIndex.section,
                                                              row: topIndex.row)
        let headerRow = provider.getHeaderRowForSubsection(section: topIndex.section,
                                                           subsection: subsectionIndex.section)
        let cell = tableView.cellForRow(at: IndexPath(row: headerRow,
                                                      section: topIndex.section))

        if
            direction == .up &&
            provider.getCount(for: topIndex.section) - 1 == topIndex.row &&
            subtractedHeaderHeight {
            // If the user is scrolling up and has reached the last cell of
            // the previous SECTION and the header cell has been removed
            // from the offset calculaton, the header for the last
            // subsection of the previous section should 'slide' down as the
            // user scrolls up. This scenario is only applicable when
            // sliding up from one tableview section to another
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
            // If the user is scrolling down and has reached the header
            // of the next subsection, the current header should stay in
            // place to give the impression that it is sliding up and out
            guard let cell = cell else {
                return
            }
            previousHeaderHeight = cell.bounds.height
            if direction == .up {
                // If the user is scrolling up and is switching subsections,
                // the previous subsection header should 'slide' down from
                // the top of the tableview
                guard subsectionIndex.section > 0 else {
                    hideHeaderCell()
                    return
                }
                let y = cell.frame.minY - headerCell.bounds.height
                let frame = CGRect(x: 0,
                                   y: y,
                                   width: tableView.frame.size.width,
                                   height: headerCell.frame.size.height)
                makeHeaderCellVisible(in: topIndex.section,
                                      for: subsectionIndex.section - 1,
                                      at: frame)
            }
            scrollUpOnLastRow = false
            return
        }

        scrollUpOnLastRow = false
        if cell != nil && (cell?.frame.minY)! > yVal {
            hideHeaderCell()
        } else {
            // Make the header of the current top cell's subsection sticky
            // at the very top of the tableview
            let frame = CGRect(x: 0, y: tableView.contentOffset.y,
                               width: tableView.frame.size.width,
                               height: headerCell.frame.size.height)
            makeHeaderCellVisible(in: topIndex.section,
                                  for: subsectionIndex.section,
                                  at: frame)
        }
    }

    func hideHeaderCell() {
        headerCell.isHidden = true
        headerClass = nil
    }

    private func getSiteTitleCell(tableView: UITableView, indexPath: IndexPath, subsection: Int) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: GradebookHeaderCell.reuseIdentifier,
                                                     for: indexPath) as? GradebookHeaderCell
            else {
                return UITableViewCell()
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
        tableView.bringSubviewToFront(headerCell)
        // Store the section and subsection being represented for the header
        // This will be used to correctly collapse and expand for taps on
        // the header cell
        headerClass = (section, subsection)
    }

    @objc private func toggleCurrentClass(sender: UITapGestureRecognizer) {
        guard let (section, subsection) = headerClass else {
            return
        }
        toggleClass(at: subsection, in: section)
    }

    private func toggleClass(at subsection: Int, in section: Int) {
        // Allows for collapsing and expanding of subsections
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
        if headerCell.frame.minY > tableView.contentOffset.y {
            hideHeaderCell()
        }
    }
}
