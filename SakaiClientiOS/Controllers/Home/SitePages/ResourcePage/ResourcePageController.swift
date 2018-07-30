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
    
    override func loadView() {
        treeView = RATreeView(frame: .zero)
        self.view = treeView
        view.backgroundColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let siteId = siteId else {
            return
        }
        
        resourceDataSourceDelegate = ResourceTreeDataSourceDelegate(treeView: treeView, siteId: siteId)

        loadData()
        configureNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ResourcePageController: LoadableController {
    @objc func loadData() {
        loadSource() {}
    }
}

extension ResourcePageController: NetworkController {
    var networkSource: ResourceTreeDataSourceDelegate {
        return resourceDataSourceDelegate
    }
}
