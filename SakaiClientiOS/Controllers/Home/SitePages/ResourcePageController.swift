//
//  ResourcePageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/28/18.
//

import ReusableSource
import RATreeView
import SafariServices

class ResourcePageController: UIViewController, SitePageController {
    
    var treeView: RATreeView!
    var resourceTreeManager: ResourceTreeManager!

    var siteId: String
    var siteUrl: String
    var pageTitle: String

    required init(siteId: String, siteUrl: String, pageTitle: String) {
        self.siteId = siteId
        self.siteUrl = siteUrl
        self.pageTitle = pageTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.title = "Resources"
        
        treeView = RATreeView(frame: view.bounds)
        view.addSubview(treeView)
        
        resourceTreeManager = ResourceTreeManager(treeView: treeView, siteId: siteId)
        resourceTreeManager.didSelectResource.delegate(to: self) { (self, url) -> Void in
            if url.absoluteString.contains("sakai.rutgers.edu") {
                let webController = WebController()
                webController.setURL(url: url)
                self.navigationController?.pushViewController(webController, animated: true)
            } else {
                let safariController = SFSafariViewController(url: url)
                self.tabBarController?.present(safariController, animated: true, completion: nil)
            }
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
