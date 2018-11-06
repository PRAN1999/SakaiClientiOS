//
//  AnnouncementController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit
import ReusableSource

class AnnouncementController: UITableViewController {
    
    var announcementTableManager : AnnouncementTableManager!
    var dateActionSheet: UIAlertController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        announcementTableManager = AnnouncementTableManager(tableView: tableView)
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
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.addBarSwipeHider()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.removeBarSwipeHider()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AnnouncementController: LoadableController {
    @objc func loadData() {
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
