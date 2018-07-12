//
//  GradebookPageControllerTableViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/22/18.
//

import UIKit

class GradebookPageController: BaseTableViewController {
    var gradebookPageDataSource: GradebookPageDataSource!
    
    init() {
        gradebookPageDataSource = GradebookPageDataSource()
        super.init(dataSource: gradebookPageDataSource)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.tableView.allowsSelection = false
        super.tableView.register(GradebookCell.self, forCellReuseIdentifier: GradebookCell.reuseIdentifier)
        
        super.viewDidLoad()
    }
}
