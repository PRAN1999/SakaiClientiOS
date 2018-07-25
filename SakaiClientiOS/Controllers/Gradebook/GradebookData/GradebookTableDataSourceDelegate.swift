//
//  GradebookTableSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/12/18.
//

import UIKit
import ReusableSource

class GradebookTableDataSourceDelegate : HideableNetworkTableDataSourceDelegate<GradebookDataProvider, GradebookCell, GradebookDataFetcher> {
    
    var controller:GradebookController!
    var headerCell:FloatingHeaderCell!
    
    init(tableView: UITableView) {
        super.init(provider: GradebookDataProvider(), fetcher: GradebookDataFetcher(), tableView: tableView)
        setupHeaderCell()
    }
    
    override func setup() {
        super.setup()
        tableView.register(SiteCell.self, forCellReuseIdentifier: SiteCell.reuseIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subsectionIndex = provider.getSubsectionIndexPath(section: indexPath.section, row: indexPath.row)
        
        if subsectionIndex.row == 0 {
            return getSiteTitleCell(tableView: tableView, indexPath: indexPath, subsection: subsectionIndex.section)
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    func getSiteTitleCell(tableView:UITableView, indexPath: IndexPath, subsection:Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SiteCell.reuseIdentifier, for: indexPath) as? SiteCell else {
            fatalError("Not a site cell")
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.none
        cell.titleLabel.text = provider.getSubsectionTitle(section: indexPath.section, subsection: subsection)
        cell.backgroundColor = UIColor(red: 199 / 255.0, green: 37 / 255.0, blue: 78 / 255.0, alpha: 1.0)
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = CGPoint(x: 0, y: tableView.contentOffset.y)
        guard let topIndex = tableView.indexPathForRow(at: point) else {
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
    
    func setupHeaderCell() {
        headerCell = FloatingHeaderCell()
        tableView.addSubview(headerCell)
    }
    
    func makeHeaderCellVisible(section:Int, subsection:Int) {
        let frame = CGRect(x: 0, y: tableView.contentOffset.y, width: tableView.frame.size.width, height: headerCell.frame.size.height)
        let title =  provider.getSubsectionTitle(section: section, subsection: subsection)
        
        headerCell.setTitle(title: title)
        headerCell.setFrameAndMakeVisible(frame: frame)
        tableView.bringSubview(toFront: headerCell)
    }
    
    func hideHeaderCell() {
        headerCell.isHidden = true
    }
    
    @objc override func handleTap(sender: UITapGestureRecognizer) {
        //hideHeaderCell()
        super.handleTap(sender: sender)
    }
}
