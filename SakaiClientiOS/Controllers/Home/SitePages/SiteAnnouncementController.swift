//
//  SiteAnnouncementController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/19/18.
//

import ReusableSource

class SiteAnnouncementController: UITableViewController, SitePageController {

    private let siteId: String
    private let siteUrl: String

    private lazy var announcementTableManager = AnnouncementTableManager(tableView: tableView)

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
        title = "Announcements"
        view.backgroundColor = UIColor.darkGray
        
        clearsSelectionOnViewWillAppear = true

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
        SakaiService.shared.siteAnnouncements[siteId] = nil
        announcementTableManager.loadDataSourceWithoutCache()
    }
}

extension SiteAnnouncementController: NetworkSourceDelegate {}
