//
//  AnnouncementDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/30/18.
//

import UIKit

class AnnouncementDataSource: BaseTableDataSourceImplementation {
    
    var announcements:[Announcement] = [Announcement]()
    
    var offset = 0
    var numToRequest = 50
    
    var moreLoads = true
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numSections
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnnouncementCell.reuseIdentifier, for: indexPath) as? AnnouncementCell else {
            fatalError("Not an announcement cell")
        }
        
        let announcement = announcements[indexPath.row]
        cell.setTitle(title: announcement.getTitle())
        
        if indexPath.row == announcements.count - 1 && moreLoads {
            let frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(70))
            let spinner = LoadingIndicator(frame: frame)
            spinner.activityIndicatorViewStyle = .gray
            spinner.color = AppGlobals.SAKAI_RED
            spinner.startAnimating()
            spinner.hidesWhenStopped = true
            
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            loadData {
                tableView.reloadData()
                tableView.tableFooterView?.isHidden = true
                spinner.stopAnimating()
            }
        }
        
        return cell
    }
    
    override func resetValues() {
        super.numRows = [0]
        super.numSections = 0
        announcements = []
        offset = 0
        numToRequest = 50
        moreLoads = true
    }
    
    override func loadData(completion: @escaping () -> Void) {
        DataHandler.shared.getAllAnnouncements(offset: offset, limit: numToRequest) { (announcementList, moreLoads) in
            self.moreLoads = moreLoads
            guard let list = announcementList else {
                completion()
                return
            }
            
            super.numSections = 1
            super.numRows[0] += list.count
            
            self.announcements.append(contentsOf: list)
            
            self.offset += list.count
            self.numToRequest += 50
            
            completion()
        }
    }
}
