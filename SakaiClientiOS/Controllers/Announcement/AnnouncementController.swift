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
        super.tableView.register(AnnouncementCell.self, forCellReuseIdentifier: AnnouncementCell.reuseIdentifier)
        announcementTableDataSourceDelegate = AnnouncementTableDataSourceDelegate(tableView: tableView)
        announcementTableDataSourceDelegate.controller = self
        loadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadData))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadData() {
        loadSource() {}
    }
}

extension AnnouncementController: NetworkController {
    var networkSource: AnnouncementTableDataSourceDelegate {
        return announcementTableDataSourceDelegate
    }
}
