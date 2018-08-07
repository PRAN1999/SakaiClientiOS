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
        super.viewDidLoad()
        gradebookTableDataSourceDelegate = GradebookTableDataSourceDelegate(tableView: super.tableView)
        gradebookTableDataSourceDelegate.controller = self
        loadData()
        self.configureNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension GradebookController: LoadableController {
    @objc func loadData() {
        gradebookTableDataSourceDelegate.hideHeaderCell()
        self.loadControllerWithoutCache() {}
    }
}

extension GradebookController: HideableNetworkController {
    
    var networkSource: GradebookTableDataSourceDelegate {
        return gradebookTableDataSourceDelegate
    }
}
