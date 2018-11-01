//
//  SiteAnnouncementController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/19/18.
//

import ReusableSource

class SiteAnnouncementController: UITableViewController, SitePageController {
    var announcementTableManager : AnnouncementTableManager!
    var siteId: String?
    var siteUrl: String?
    var pageTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Announcements"
        
        guard let id = siteId else {
            return
        }
        
        self.clearsSelectionOnViewWillAppear = true
        
        announcementTableManager = AnnouncementTableManager(tableView: tableView)
        announcementTableManager.siteId = id
        announcementTableManager.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            guard let announcement = self.announcementTableManager.item(at: indexPath) else {
                return
            }
            let announcementPage = AnnouncementPageController()
            announcementPage.setAnnouncement(announcement)
            self.navigationController?.pushViewController(announcementPage, animated: true)
        }
        announcementTableManager.delegate = self
        configureNavigationItem()
        announcementTableManager.loadDataSource()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addBarSwipeHider()
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeBarSwipeHider()
    }
}

extension SiteAnnouncementController: LoadableController {
    @objc func loadData() {
        announcementTableManager.loadDataSourceWithoutCache()
    }
}

extension SiteAnnouncementController: FeedController {
    @objc func swipeTarget() {
        setTabBarVisibility()
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
}

extension SiteAnnouncementController: NetworkSourceDelegate {}
