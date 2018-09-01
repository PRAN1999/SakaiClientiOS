//
//  HomeController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/23/18.

import Foundation
import UIKit
import ReusableSource

class HomeController: UITableViewController {
    
    var siteTableManager: SiteTableManager!
    var logoutController: UIAlertController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Classes"
        disableTabs()
        siteTableManager = SiteTableManager(tableView: tableView)
        siteTableManager.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            let classController:ClassController = ClassController()
            guard let site:Site = self.siteTableManager.item(at: indexPath) else {
                return
            }
            classController.setPages(pages: site.pages)
            classController.siteTitle = site.title
            self.navigationController?.pushViewController(classController, animated: true)
        }
        siteTableManager.delegate = self

        self.configureNavigationItem()
        setupLogoutController()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(presentLogoutController))
        self.navigationController?.toolbar.barTintColor = UIColor.black

        let loginController = LoginViewController()
        loginController.onLogin = { [weak self] in
            self?.loadData()
            self?.tabBarController?.dismiss(animated: true, completion: nil)
        }
        let navController = WebViewNavigationController(rootViewController: loginController)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.tabBarController?.present(navController, animated: true, completion: nil)
        }
    }
    
    func disableTabs() {
        let items = self.tabBarController?.tabBar.items
        if let arr = items {
            for index in 1..<arr.count {
                arr[index].isEnabled = false
            }
        }
    }
    
    func enableTabs() {
        let items = self.tabBarController?.tabBar.items
        if let arr = items {
            for index in 1..<arr.count {
                arr[index].isEnabled = true
            }
        }
    }
    
    func setupLogoutController() {
        logoutController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (action) in
            RequestManager.shared.logout()
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
        self.siteTableManager.loadDataSourceWithoutCache()
    }
}

extension HomeController: NetworkSourceDelegate {

    func networkSource<Source>(willBeginLoadingDataSource networkSource: Source) -> (() -> ())? where Source : NetworkSource {
        disableTabs()
        SakaiService.shared.reset()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let callback = self.addLoadingIndicator()
        return { [weak self] in
            callback()
            self?.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    func networkSource<Source>(successfullyLoadedDataSource networkSource: Source?) where Source : NetworkSource {
        enableTabs()
    }
}
