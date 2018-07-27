//
//  HomeController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/23/18.

import Foundation
import UIKit
import ReusableSource

class HomeController: UITableViewController {
    
    var siteTableDataSourceDelegate: SiteTableDataSourceDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Classes"
        
        siteTableDataSourceDelegate = SiteTableDataSourceDelegate(tableView: tableView)
        siteTableDataSourceDelegate.controller = self
        loadData()
        self.configureNavigationItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func disableTabs() {
        let items = self.tabBarController?.tabBar.items
        
        if let arr = items {
            for i in 1..<5 {
                arr[i].isEnabled = false
            }
        }
    }
    
    func enableTabs() {
        let items = self.tabBarController?.tabBar.items
        
        if let arr = items {
            for i in 1..<5 {
                arr[i].isEnabled = true
            }
        }
    }
}

extension HomeController: LoadableController {
    @objc func loadData() {
        disableTabs()
        SakaiService.shared.reset()
        self.loadSourceWithoutCache() {
            self.enableTabs()
        }
    }
}

extension HomeController: NetworkController {
    var networkSource: SiteTableDataSourceDelegate {
        return siteTableDataSourceDelegate
    }
}
