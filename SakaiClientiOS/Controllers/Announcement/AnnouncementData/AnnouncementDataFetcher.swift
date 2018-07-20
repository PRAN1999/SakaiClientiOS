//
//  AnnouncementDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import ReusableSource

class AnnouncementDataFetcher: DataFetcher, FeedDataFetcher {
    
    var siteId: String?
    
    typealias T = [Announcement]
    
    var offset = 0
    var numToRequest = 50
    
    var moreLoads = true
    
    func loadData(completion: @escaping ([Announcement]?) -> Void) {
        DataHandler.shared.getAllAnnouncements(offset: offset, limit: numToRequest, completion: { (announcementList, moreLoads) in
            self.moreLoads = moreLoads
            
            guard let list = announcementList else {
                completion(nil)
                return
            }
            self.offset += list.count
            self.numToRequest += 50
            
            completion(announcementList)
        }, siteId: siteId)
    }
    
    func resetOffset() {
        offset = 0
        numToRequest = 50
        moreLoads = true
    }
}
