//
//  BaseTableViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/4/18.
//

import UIKit

class BaseTableViewController: UITableViewController {

    var dataSource: BaseTableDataSource!
    var indicator: LoadingIndicator!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Must initialize Controller with dataSource")
    }
    
    init?(coder aDecoder: NSCoder, dataSource:BaseTableDataSource) {
        super.init(coder: aDecoder)
        self.dataSource = dataSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadDataSourceWithoutCache))
        
        indicator = LoadingIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), view: self.tableView)
        indicator.hidesWhenStopped = true
        loadDataSource()
    }
    
    @objc func loadDataSource() {
        dataSource.resetValues()
        self.tableView.reloadData()
        
        indicator.startAnimating()
        dataSource.hasLoaded = false
        dataSource.isLoading = true
        
        dataSource.loadData(completion: {
            self.tableView.reloadData()
            
            self.indicator.stopAnimating()
            self.dataSource.hasLoaded = true
            self.dataSource.isLoading = false
        })
    }
    
    @objc func loadDataSourceWithoutCache() {
        RequestManager.shared.resetCache()
        loadDataSource()
    }
}
