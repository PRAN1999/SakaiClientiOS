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
    var resourceDataSourceDelegate: ResourceTreeDataSourceDelegate!
    var siteId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.title = "Resources"
        
        guard let siteId = siteId else {
            return
        }
        
        treeView = RATreeView(frame: view.bounds)
        view.addSubview(treeView)
        
        resourceDataSourceDelegate = ResourceTreeDataSourceDelegate(treeView: treeView, siteId: siteId)
        resourceDataSourceDelegate.didSelectResource.delegate(to: self) { (self, url) -> Void in
            let webController = WebController()
            webController.setURL(url: url)
            self.navigationController?.pushViewController(webController, animated: true)
        }

        loadData()
        configureNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ResourcePageController: LoadableController {
    @objc func loadData() {
        loadController() {}
    }
}

extension ResourcePageController: NetworkController {
    var networkSource: ResourceTreeDataSourceDelegate {
        return resourceDataSourceDelegate
    }
}
