//
//  ResourcePageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/28/18.
//

import ReusableSource
import RATreeView
import UIKit

class ResourcePageController: UIViewController, SitePageController {
    
    var treeView: RATreeView!
    var resourceTreeManager: ResourceTreeManager!
    var siteId: String?
    var siteUrl: String?
    var pageTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.title = "Resources"
        
        guard let siteId = siteId else {
            return
        }
        
        treeView = RATreeView(frame: view.bounds)
        view.addSubview(treeView)
        
        resourceTreeManager = ResourceTreeManager(treeView: treeView, siteId: siteId)
        resourceTreeManager.didSelectResource.delegate(to: self) { (self, url) -> Void in
            let webController = WebController()
            webController.setURL(url: url)
            self.navigationController?.pushViewController(webController, animated: true)
        }
        resourceTreeManager.delegate = self

        configureNavigationItem()
        resourceTreeManager.loadDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ResourcePageController: LoadableController {
    @objc func loadData() {
        resourceTreeManager.loadDataSourceWithoutCache()
    }
}

extension ResourcePageController: NetworkSourceDelegate {}
