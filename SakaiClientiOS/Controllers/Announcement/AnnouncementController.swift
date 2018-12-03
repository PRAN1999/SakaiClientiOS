//
//  AnnouncementController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit
import ReusableSource

class AnnouncementController: UITableViewController {
    
    private(set) lazy var announcementTableManager = AnnouncementTableManager(tableView: tableView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        announcementTableManager.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            guard let announcement = self.announcementTableManager.item(at: indexPath) else {
                return
            }
            let announcementPage = AnnouncementPageController(announcement: announcement)
            self.navigationController?.pushViewController(announcementPage, animated: true)
        }
        announcementTableManager.delegate = self
        configureNavigationItem()
        loadData()
    }
}

extension AnnouncementController: LoadableController {
    @objc func loadData() {
        SakaiService.shared.allAnnouncements = nil
        self.announcementTableManager.loadDataSourceWithoutCache()
    }
}

extension AnnouncementController: FeedController {
    @objc func swipeTarget() {
        self.setTabBarVisibility()
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
}

extension AnnouncementController: NetworkSourceDelegate {}
