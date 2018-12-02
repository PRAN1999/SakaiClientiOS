//
//  SiteAnnouncementController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/19/18.
//

import ReusableSource

class SiteAnnouncementController: UITableViewController, SitePageController {

    var siteId: String
    var siteUrl: String
    var pageTitle: String

    var announcementTableManager : AnnouncementTableManager!
    var dateActionSheet: UIAlertController!

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
        self.title = "Announcements"
        
        self.clearsSelectionOnViewWillAppear = true
        
        announcementTableManager = AnnouncementTableManager(tableView: tableView)
        announcementTableManager.siteId = siteId
        announcementTableManager.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            guard let announcement = self.announcementTableManager.item(at: indexPath) else {
                return
            }
            let announcementPage = AnnouncementPageController(announcement: announcement)
            self.navigationController?.pushViewController(announcementPage, animated: true)
        }
        announcementTableManager.delegate = self
        configureNavigationItem()
        announcementTableManager.loadDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension SiteAnnouncementController: LoadableController {
    @objc func loadData() {
        announcementTableManager.loadDataSourceWithoutCache()
    }
}

extension SiteAnnouncementController: NetworkSourceDelegate {}
