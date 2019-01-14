//
//  ResourcePageViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/28/18.
//

import ReusableSource
import RATreeView
import SafariServices

/// Manages the screen for the Resources page of a certain Site using a
/// RATreeView. Presents WebViewController or SFSafariViewController for
/// different Resources
class ResourcePageViewController: UIViewController {
    
    private let treeView: RATreeView = RATreeView(frame: .zero)
    private lazy var resourceTreeManager = ResourceTreeManager(treeView: treeView,
                                                               siteId: siteId)

    private let siteId: String

    required init(siteId: String) {
        self.siteId = siteId
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

        view.addSubview(treeView)
        treeView.constrainToEdges(of: view)

        resourceTreeManager.didSelectResource.delegate(to: self) { (self, url) -> Void in
            if url.absoluteString.contains("sakai.rutgers.edu") {
                let webController = WebViewController()
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

//MARK: LoadableController Extension

extension ResourcePageViewController: LoadableController {
    @objc func loadData() {
        resourceTreeManager.loadDataSourceWithoutCache()
    }
}

//MARK: NetworkSourceDelegate Extension

extension ResourcePageViewController: NetworkSourceDelegate {}
