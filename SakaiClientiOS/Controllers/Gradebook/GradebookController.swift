//
//  GradebookController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit
import ReusableSource

/// The view controller for the main Gradebook tab
class GradebookController: UITableViewController {
    
    /// Abstract Gradebook data management and delegate
    var gradebookTableManager: GradebookTableManager!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradebookTableManager = GradebookTableManager(tableView: super.tableView)
        gradebookTableManager.delegate = self
        configureNavigationItem()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension GradebookController: LoadableController {
    @objc func loadData() {
        gradebookTableManager.loadDataSourceWithoutCache()
    }
}

extension GradebookController: NetworkSourceDelegate {
    func networkSourceWillBeginLoadingData<Source>(_ networkSource: Source) -> (() -> Void)? where Source : NetworkSource {
        gradebookTableManager.hideHeaderCell()
        return self.addLoadingIndicator()
    }
}
