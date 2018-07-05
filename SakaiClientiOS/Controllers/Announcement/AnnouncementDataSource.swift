//
//  AnnouncementDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/30/18.
//

import UIKit

class AnnouncementDataSource: NSObject, BaseTableDataSource {
    
    var announcements:[Announcement] = [Announcement]()
    
    var numRows: [Int] = [Int]()
    var numSections: Int = 0
    
    var hasLoaded: Bool = false
    var isLoading: Bool = false
    
    func loadData(completion: @escaping () -> Void) {
        completion()
    }
    
    func resetValues() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
