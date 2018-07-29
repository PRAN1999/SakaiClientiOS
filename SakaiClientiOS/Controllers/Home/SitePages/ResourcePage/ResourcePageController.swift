//
//  ResourcePageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/28/18.
//

import ReusableSource
import RATreeView

class ResourcePageController: UIViewController, SitePageController {
    
    var treeView: RATreeView!
    var resourceDataSourceDelegate: ResourceTreeDataSourceDelegate!
    var siteId: String?
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let siteId = siteId else {
            return
        }
        
        treeView = RATreeView(frame: view.bounds)
        resourceDataSourceDelegate = ResourceTreeDataSourceDelegate(treeView: treeView, siteId: siteId)
        self.view.addSubview(treeView)
        
        loadData()
        configureNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ResourcePageController: LoadableController {
    func loadData() {
        loadSource() {}
    }
}

extension ResourcePageController: NetworkController {
    var networkSource: ResourceTreeDataSourceDelegate {
        return resourceDataSourceDelegate
    }
}
