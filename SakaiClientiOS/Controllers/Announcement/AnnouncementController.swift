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
        announcementTableDataSourceDelegate.controller = self
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
        self.loadSourceWithoutCache() {}
    }
}

extension AnnouncementController: FeedController {
    @objc func swipeTarget() {
        self.setTabBarVisibility()
    }
}

extension AnnouncementController: NetworkController {
    var networkSource: AnnouncementTableDataSourceDelegate {
        return announcementTableDataSourceDelegate
    }
}
