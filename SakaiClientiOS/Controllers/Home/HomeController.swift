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
    var logoutController: UIAlertController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Classes"
        
        siteTableDataSourceDelegate = SiteTableDataSourceDelegate(tableView: tableView)
        siteTableDataSourceDelegate.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            let classController:ClassController = ClassController()
            guard let site:Site = self.siteTableDataSourceDelegate.item(at: indexPath) else {
                return
            }
            classController.setPages(pages: site.pages)
            classController.siteTitle = site.title
            self.navigationController?.pushViewController(classController, animated: true)
        }
        
        loadData()
        self.configureNavigationItem()
        setupLogoutController()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(presentLogoutController))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func disableTabs() {
        let items = self.tabBarController?.tabBar.items
        
        if let arr = items {
            for i in 1..<arr.count {
                arr[i].isEnabled = false
            }
        }
    }
    
    func enableTabs() {
        let items = self.tabBarController?.tabBar.items
        
        if let arr = items {
            for i in 1..<arr.count {
                arr[i].isEnabled = true
            }
        }
    }
    
    func setupLogoutController() {
        logoutController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (action) in
            RequestManager.shared.logout() {}
        }
        logoutController.addAction(logoutAction)
        logoutController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    @objc func presentLogoutController() {
        self.present(logoutController, animated: true, completion: nil)
    }
}

extension HomeController: LoadableController {
    @objc func loadData() {
        disableTabs()
        SakaiService.shared.reset()
        self.loadControllerWithoutCache() {
            self.enableTabs()
        }
    }
}

extension HomeController: NetworkController {
    var networkSource: SiteTableDataSourceDelegate {
        return siteTableDataSourceDelegate
    }
}
