//
//  BaseTableViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/4/18.
//

import UIKit

class BaseTableViewController: UITableViewController {

    var baseDataSource: BaseTableDataSource!
    var indicator: LoadingIndicator!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Must initialize Controller with dataSource")
    }
    
    init?(coder aDecoder: NSCoder, dataSource:BaseTableDataSource) {
        super.init(coder: aDecoder)
        self.baseDataSource = dataSource
    }
    
    init(dataSource:BaseTableDataSource) {
        super.init(style: .plain)
        self.baseDataSource = dataSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.baseDataSource
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadDataSourceWithoutCache))
        
        indicator = LoadingIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), view: self.tableView)
        indicator.hidesWhenStopped = true
        
        loadDataSource()
    }
    
    @objc func loadDataSource() {
        baseDataSource.resetValues()
        self.tableView.reloadData()
        
        indicator.startAnimating()
        baseDataSource.hasLoaded = false
        baseDataSource.isLoading = true
        
        baseDataSource.loadData(completion: {
            self.tableView.reloadData()
            
            self.indicator.stopAnimating()
            self.baseDataSource.hasLoaded = true
            self.baseDataSource.isLoading = false
            
            self.callBack()
        })
    }
    
    @objc func loadDataSourceWithoutCache() {
        RequestManager.shared.resetCache()
        loadDataSource()
    }
    
    func callBack() {
        
    }
}
