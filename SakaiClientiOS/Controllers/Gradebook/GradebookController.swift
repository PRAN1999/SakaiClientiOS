//
//  GradebookController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit
import ReusableSource

class GradebookController: UITableViewController {
    
    var gradebookTableManager: GradebookTableManager!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradebookTableManager = GradebookTableManager(tableView: super.tableView)
        gradebookTableManager.delegate = self
        loadData()
        self.configureNavigationItem()
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
