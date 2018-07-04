//
//  AnnouncementController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit

class AnnouncementController: UITableViewController {
    
    var isSitePage: Bool = false
    var siteId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    func loadData() {
        
    }
    
    func loadData(for siteId:String) {
        
    }
}
