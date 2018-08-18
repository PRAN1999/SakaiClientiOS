//
//  AnnouncementController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit
import ReusableSource

class AnnouncementController: UITableViewController {
    
    var announcementTableDataSourceDelegate : AnnouncementTableDataSourceDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        announcementTableDataSourceDelegate = AnnouncementTableDataSourceDelegate(tableView: tableView)
        announcementTableDataSourceDelegate.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            guard let announcement = self.announcementTableDataSourceDelegate.item(at: indexPath) else {
                return
            }
            let announcementPage = AnnouncementPageController()
            announcementPage.setAnnouncement(announcement)
            self.navigationController?.pushViewController(announcementPage, animated: true)
        }
        loadData()
        self.configureNavigationItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.addBarSwipeHider()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.removeBarSwipeHider()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AnnouncementController: LoadableController {
    @objc func loadData() {
        self.loadControllerWithoutCache() {}
    }
}

extension AnnouncementController: FeedController {
    @objc func swipeTarget() {
        self.setTabBarVisibility()
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
}

extension AnnouncementController: NetworkController {
    var networkSource: AnnouncementTableDataSourceDelegate {
        return announcementTableDataSourceDelegate
    }
}
