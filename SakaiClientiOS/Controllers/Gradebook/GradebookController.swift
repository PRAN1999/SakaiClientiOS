//
//  GradebookController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit
import ReusableSource

class GradebookController: UITableViewController {
    
    var gradebookTableDataSourceDelegate: GradebookTableDataSourceDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.tableView.allowsSelection = false
        super.tableView.register(TermHeader.self, forHeaderFooterViewReuseIdentifier: TermHeader.reuseIdentifier)
        super.tableView.showsVerticalScrollIndicator = false
        gradebookTableDataSourceDelegate = GradebookTableDataSourceDelegate(tableView: super.tableView)
        gradebookTableDataSourceDelegate.controller = self
        loadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadData))
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadData() {
        gradebookTableDataSourceDelegate.hideHeaderCell()
        loadSourceWithoutCache() {}
    }
}

extension GradebookController: HideableNetworkController {
    
    var networkSource: GradebookTableDataSourceDelegate {
        return gradebookTableDataSourceDelegate
    }
}
