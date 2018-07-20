//
//  AnnouncementPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/19/18.
//

import ReusableSource

class SiteAnnouncementController: UITableViewController {
    var announcementTableDataSourceDelegate : AnnouncementTableDataSourceDelegate!
    var siteId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.tableView.register(AnnouncementCell.self, forCellReuseIdentifier: AnnouncementCell.reuseIdentifier)
        announcementTableDataSourceDelegate = AnnouncementTableDataSourceDelegate(tableView: tableView)
        announcementTableDataSourceDelegate.controller = self
        announcementTableDataSourceDelegate.siteId = siteId
        loadSource {}
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadData))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadData() {
        loadSourceWithoutCache() {}
    }
}

extension SiteAnnouncementController: NetworkController {
    var networkSource: AnnouncementTableDataSourceDelegate {
        return announcementTableDataSourceDelegate
    }
}
