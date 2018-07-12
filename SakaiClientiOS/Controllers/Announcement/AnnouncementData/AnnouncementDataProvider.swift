//
//  AnnouncementDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import ReusableSource

class AnnouncementDataProvider: DataProvider {
    
    typealias T = Announcement
    typealias V = [Announcement]
    
    var announcements: [Announcement] = []
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return announcements.count
    }
    
    func item(at indexPath: IndexPath) -> Announcement? {
        return announcements[indexPath.row]
    }
    
    func resetValues() {
        announcements = []
    }
    
    func loadItems(payload: [Announcement]) {
        announcements.append(contentsOf: payload)
    }
    
    func lastAssignmentIndex() -> Int {
        return announcements.count - 1
    }
    
}
