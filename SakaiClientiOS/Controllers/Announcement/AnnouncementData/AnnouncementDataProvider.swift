//
//  AnnouncementDataProvider.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//
import ReusableSource

class AnnouncementDataProvider: SingleSectionDataProvider<Announcement> {
    
    override func loadItems(payload: [Announcement]) {
        items.append(contentsOf: payload)
    }
    
    func lastAssignmentIndex() -> Int {
        return items.count - 1
    }
    
}
