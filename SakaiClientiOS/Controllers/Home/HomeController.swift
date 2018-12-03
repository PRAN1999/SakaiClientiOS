//
//  HomeController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/23/18.

import Foundation
import UIKit
import ReusableSource

class HomeController: UITableViewController {
    
    private lazy var siteTableManager = SiteTableManager(tableView: tableView)

    private let logoutController: UIAlertController = {
        let logoutController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (action) in
            RequestManager.shared.logout()
        }
        logoutController.addAction(logoutAction)
        logoutController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return logoutController
    }()

    private var launchedInBackground = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Classes"
        disableTabs()
        siteTableManager.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            guard let site = self.siteTableManager.item(at: indexPath) else {
                return
            }
            let classController = ClassController(pages: site.pages)
            self.navigationController?.pushViewController(classController, animated: true)
        }
        siteTableManager.delegate = self

        configureNavigationItem()
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: ReloadActions.reload.rawValue), object: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(presentLogoutController))
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: Notification.Name(rawValue: ReloadActions.reloadHome.rawValue), object: nil)

        if UIApplication.shared.applicationState == .background {
            print("launched in background")
            launchedInBackground = true
            return
        }

        authenticateAndLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if launchedInBackground {
            authenticateAndLoad()
            launchedInBackground = false
        }
    }

    private func authenticateAndLoad() {
        if RequestManager.shared.loadCookiesFromUserDefaults() {
            SakaiService.shared.validateLoggedInStatus(
                onSuccess: { [weak self] in
                    self?.loadData()
                }, onFailure: { [weak self] err in
                    self?.performLoginFlow()
                }
            )
            return
        }

        performLoginFlow()
    }

    private func performLoginFlow() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        guard let navController = storyboard.instantiateViewController(withIdentifier: "loginNavigation") as? UINavigationController else {
            return
        }
        guard let loginController = navController.viewControllers.first as? LoginController else {
            return
        }
        loginController.onLogin = { [weak self] in
            self?.loadData()
            self?.tabBarController?.dismiss(animated: true, completion: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.tabBarController?.present(navController, animated: true, completion: nil)
        }
    }
    
    private func disableTabs() {
        let items = tabBarController?.tabBar.items
        if let arr = items {
            for index in 1..<arr.count {
                arr[index].isEnabled = false
            }
        }
    }
    
    private func enableTabs() {
        let items = tabBarController?.tabBar.items
        if let arr = items {
            for index in 1..<arr.count {
                arr[index].isEnabled = true
            }
        }
    }
    
    @objc private func presentLogoutController() {
        present(logoutController, animated: true, completion: nil)
    }
}

extension HomeController: LoadableController {
    @objc func loadData() {
        siteTableManager.loadDataSourceWithoutCache()
    }
}

extension HomeController: NetworkSourceDelegate {
    func networkSourceWillBeginLoadingData<Source>(_ networkSource: Source) -> (() -> Void)? where Source : NetworkSource {
        disableTabs()
        SakaiService.shared.reset()
        return addLoadingIndicator()
    }

    func networkSourceSuccessfullyLoadedData<Source>(_ networkSource: Source?) where Source : NetworkSource {
        enableTabs()
        NotificationCenter.default.post(name: Notification.Name(rawValue: ReloadActions.reload.rawValue), object: nil)
        RequestManager.shared.isLoggedIn = true
    }
}
