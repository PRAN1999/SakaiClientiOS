//
//  HomeController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/23/18.

import Foundation
import UIKit

class HomeController: UITableViewController, ReusableController {
    typealias Provider = SiteDataProvider
    typealias Cell = SiteCell
    typealias Fetcher = SiteDataFetcher
    
    var siteTableSource: SiteTableSource!
    var tableSource: ReusableTableSource<SiteDataProvider, SiteCell, SiteDataFetcher> {
        return siteTableSource
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.title = "Classes"
        super.tableView.register(SiteCell.self, forCellReuseIdentifier: SiteCell.reuseIdentifier)
        super.tableView.register(TermHeader.self, forHeaderFooterViewReuseIdentifier: TermHeader.reuseIdentifier)
        
        siteTableSource = SiteTableSource(tableView: tableView)
        siteTableSource.controller = self
        loadTableSource()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadData))
        //self.setupSearchBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func loadData() {
        loadTableSource()
    }
}
