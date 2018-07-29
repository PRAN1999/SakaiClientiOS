//
//  AnnouncementPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/19/18.
//

import ReusableSource

class SiteAnnouncementController: UITableViewController, SitePageController {
    var announcementTableDataSourceDelegate : AnnouncementTableDataSourceDelegate!
    var siteId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = siteId else {
            return
        }
        
        announcementTableDataSourceDelegate = AnnouncementTableDataSourceDelegate(tableView: tableView)
        announcementTableDataSourceDelegate.controller = self
        announcementTableDataSourceDelegate.siteId = id
        self.loadSource {}
        self.configureNavigationItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.addBarSwipeHider()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeBarSwipeHider()
    }
}

extension SiteAnnouncementController: LoadableController {
    @objc func loadData() {
        self.loadSourceWithoutCache() {}
    }
}

extension SiteAnnouncementController: FeedController {
    @objc func swipeTarget() {
        setTabBarVisibility()
    }
}

extension SiteAnnouncementController: NetworkController {
    var networkSource: AnnouncementTableDataSourceDelegate {
        return announcementTableDataSourceDelegate
    }
}
