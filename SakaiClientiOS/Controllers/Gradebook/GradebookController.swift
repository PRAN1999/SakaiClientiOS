//
//  GradebookController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit

class GradebookController: CollapsibleSectionController {
    
    var gradebookDataSource: GradebookDataSource!
    
    var headerCell:FloatingHeaderCell!
    
    required init?(coder aDecoder: NSCoder) {
        gradebookDataSource = GradebookDataSource()
        super.init(coder: aDecoder, dataSource: gradebookDataSource)
    }
    
    override func viewDidLoad() {
        super.tableView.allowsSelection = false
        super.tableView.register(GradebookCell.self, forCellReuseIdentifier: GradebookCell.reuseIdentifier)
        super.tableView.register(SiteCell.self, forCellReuseIdentifier: SiteCell.reuseIdentifier)
        super.tableView.register(TermHeader.self, forHeaderFooterViewReuseIdentifier: TermHeader.reuseIdentifier)
        
        setupHeaderCell()
        super.tableView.showsVerticalScrollIndicator = false
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc override func handleTap(sender: UITapGestureRecognizer) {
        //hideHeaderCell()
        super.handleTap(sender: sender)
    }
    
    @objc override func loadDataSource() {
        hideHeaderCell()
        super.loadDataSource()
    }
}

extension GradebookController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let point = CGPoint(x: 0, y: tableView.contentOffset.y)
        guard let topIndex = tableView.indexPathForRow(at: point) else {
            hideHeaderCell()
            return
        }
        
        let subsectionIndex = gradebookDataSource.getSubsectionIndexPath(section: topIndex.section, row: topIndex.row)
        let headerRow = gradebookDataSource.getHeaderRowForSubsection(section: topIndex.section, indexPath: subsectionIndex)
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
        let title =  gradebookDataSource.getSubsectionTitle(section: section, subsection: subsection)
        
        headerCell.setTitle(title: title)
        headerCell.setFrameAndMakeVisible(frame: frame)
        tableView.bringSubview(toFront: headerCell)
    }
    
    func hideHeaderCell() {
        headerCell.isHidden = true
    }
}
