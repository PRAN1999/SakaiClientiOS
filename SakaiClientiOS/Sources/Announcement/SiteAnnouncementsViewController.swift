//
//  SiteAnnouncementsViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/19/18.
//

import ReusableSource

/// View controller for Site Announcements feed
class SiteAnnouncementsViewController: UITableViewController {

    private let siteId: String

    private lazy var announcementTableManager = AnnouncementTableManager(tableView: tableView)

    required init(siteId: String) {
        self.siteId = siteId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Announcements"
        view.backgroundColor = Palette.main.primaryBackgroundColor
        
        clearsSelectionOnViewWillAppear = true

        announcementTableManager.siteId = siteId
        announcementTableManager.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            guard let announcement = self.announcementTableManager.item(at: indexPath) else {
                return
            }
            let announcementPage = AnnouncementPageViewController(announcement: announcement)
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

// MARK: LoadableController Extension

extension SiteAnnouncementsViewController: LoadableController {
    @objc func loadData() {
        announcementTableManager.loadDataSourceWithoutCache()
    }
}

// MARK: NetworkSourceDelegate Extension

extension SiteAnnouncementsViewController: NetworkSourceDelegate {}
