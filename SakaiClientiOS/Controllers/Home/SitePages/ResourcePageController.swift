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
    
    private let treeView: RATreeView = RATreeView(frame: .zero)
    private lazy var resourceTreeManager = ResourceTreeManager(treeView: treeView, siteId: siteId)

    private let siteId: String
    private let siteUrl: String

    required init(siteId: String, siteUrl: String, pageTitle: String) {
        self.siteId = siteId
        self.siteUrl = siteUrl
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.main.primaryBackgroundColor
        self.title = "Resources"
        treeView.treeFooterView = UIView()

        UIView.constrainChildToEdges(child: treeView, parent: view)

        resourceTreeManager.didSelectResource.delegate(to: self) { (self, url) -> Void in
            if url.absoluteString.contains("sakai.rutgers.edu") {
                let webController = WebController()
                webController.setURL(url: url)
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(webController, animated: true)
                self.hidesBottomBarWhenPushed = false
            } else {
                let safariController = SFSafariViewController(url: url)
                self.tabBarController?.present(safariController, animated: true, completion: nil)
            }
        }
        resourceTreeManager.delegate = self

        configureNavigationItem()
        resourceTreeManager.loadDataSource()
    }
}

extension ResourcePageController: LoadableController {
    @objc func loadData() {
        resourceTreeManager.loadDataSourceWithoutCache()
    }
}

extension ResourcePageController: NetworkSourceDelegate {}
