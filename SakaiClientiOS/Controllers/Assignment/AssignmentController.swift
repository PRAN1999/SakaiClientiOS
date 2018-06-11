//
//  AssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit

class AssignmentController: CollapsibleSectionController {
    
    let TABLE_CELL_HEIGHT:CGFloat = 40.0
    
    var siteAssignmentsDataSource: SiteAssignmentsDataSource = SiteAssignmentsDataSource()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, dataSource: siteAssignmentsDataSource)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        self.tableView.register(SiteAssignmentsCell.self, forCellReuseIdentifier: SiteAssignmentsCell.reuseIdentifier)
        self.tableView.register(TermHeader.self, forHeaderFooterViewReuseIdentifier: TermHeader.reuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
