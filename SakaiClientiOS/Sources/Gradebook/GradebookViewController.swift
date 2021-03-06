//
//  GradebookViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit
import ReusableSource

/// The view controller for the main Gradebook tab
class GradebookViewController: UITableViewController {
    
    /// Abstract Gradebook data management and delegate
    private lazy var gradebookTableManager: GradebookTableManager
        = GradebookTableManager(tableView: tableView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradebookTableManager.delegate = self
        configureNavigationItem()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: LoadableController Extension

extension GradebookViewController: LoadableController {
    @objc func loadData() {
        gradebookTableManager.hideHeaderCell()
        gradebookTableManager.loadDataSourceWithoutCache()
    }
}

// MARK: NetworkSourceDelegate Extension

extension GradebookViewController: NetworkSourceDelegate {
    func networkSourceWillBeginLoadingData<Source>(_ networkSource: Source)
        -> (() -> Void)? where Source: NetworkSource {
        //gradebookTableManager.hideHeaderCell()
        return self.addLoadingIndicator()
    }
}
