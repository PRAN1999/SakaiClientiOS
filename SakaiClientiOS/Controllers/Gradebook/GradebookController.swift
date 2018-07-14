//
//  GradebookController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit
import ReusableSource

class GradebookController: UITableViewController {
    
    var gradebookTableSource: GradebookTableSource!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.tableView.allowsSelection = false
        super.tableView.register(GradebookCell.self, forCellReuseIdentifier: GradebookCell.reuseIdentifier)
        super.tableView.register(SiteCell.self, forCellReuseIdentifier: SiteCell.reuseIdentifier)
        super.tableView.register(TermHeader.self, forHeaderFooterViewReuseIdentifier: TermHeader.reuseIdentifier)
        super.tableView.showsVerticalScrollIndicator = false
        
        gradebookTableSource = GradebookTableSource(tableView: super.tableView)
        gradebookTableSource.controller = self
        loadTableSource()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadData))
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadData() {
        loadTableSource()
    }
}

extension GradebookController: ReusableController {
    typealias Provider = GradebookDataProvider
    typealias Cell = GradebookCell
    typealias Fetcher = GradebookDataFetcher
    
    var reusableSource: ReusableTableSource<GradebookDataProvider, GradebookCell, GradebookDataFetcher> {
        return gradebookTableSource
    }
}
