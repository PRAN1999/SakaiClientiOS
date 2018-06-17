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
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        
        self.tableView.register(GradebookCell.self, forCellReuseIdentifier: GradebookCell.reuseIdentifier)
        self.tableView.register(SiteCell.self, forCellReuseIdentifier: SiteCell.reuseIdentifier)
        self.tableView.register(TermHeader.self, forHeaderFooterViewReuseIdentifier: TermHeader.reuseIdentifier)
        
        self.setupHeaderCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc override func handleTap(sender: UITapGestureRecognizer) {
        self.hideHeaderCell()
        super.handleTap(sender: sender)
    }
}

extension GradebookController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let point = CGPoint(x: 0, y: self.tableView.contentOffset.y + super.TABLE_HEADER_HEIGHT + 1)
        guard let topIndex = self.tableView.indexPathForRow(at: point) else {
            self.hideHeaderCell()
            return
        }
        
        let subsectionIndex = self.gradebookDataSource.getSubsectionIndexPath(section: topIndex.section, row: topIndex.row)
        let headerRow = self.gradebookDataSource.getHeaderRowForSubsection(section: topIndex.section, indexPath: subsectionIndex)
        let cell = self.tableView.cellForRow(at: IndexPath(row: headerRow, section: topIndex.section))
        
        if(cell != nil && (cell?.frame.maxY)! > self.tableView.contentOffset.y + self.TABLE_HEADER_HEIGHT * 2) {
            self.hideHeaderCell()
        } else {
            self.makeHeaderCellVisible(section: topIndex.section, subsection: subsectionIndex.section)
        }
    }
    
    func setupHeaderCell() {
        self.headerCell = FloatingHeaderCell()
        self.tableView.addSubview(headerCell)
    }
    
    func makeHeaderCellVisible(section:Int, subsection:Int) {
        let frame = CGRect(x: 0, y: self.tableView.contentOffset.y + super.TABLE_HEADER_HEIGHT, width: self.tableView.frame.size.width, height: self.headerCell.frame.size.height)
        let title =  self.gradebookDataSource.getSubsectionTitle(section: section, subsection: subsection)
        
        self.headerCell.setTitle(title: title)
        self.headerCell.setFrameAndMakeVisible(frame: frame)
        self.tableView.bringSubview(toFront: self.headerCell)
    }
    
    func hideHeaderCell() {
        self.headerCell.isHidden = true
    }
}
