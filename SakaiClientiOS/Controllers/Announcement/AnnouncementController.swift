//
//  AnnouncementController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit

class AnnouncementController: BaseTableViewController {
    
    var announcementDataSource:AnnouncementDataSource!
    
    required init?(coder aDecoder: NSCoder) {
        announcementDataSource = AnnouncementDataSource()
        super.init(coder: aDecoder, dataSource: announcementDataSource)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.tableView.register(AnnouncementCell.self, forCellReuseIdentifier: AnnouncementCell.reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
