//
//  AnnouncementDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import ReusableSource

class AnnouncementDataFetcher: DataFetcher {
    
    private static let REQUEST_LIMIT = 35
    
    typealias T = [Announcement]
    
    var daysBack = 180
    var offset = 0
    var numToRequest = AnnouncementDataFetcher.REQUEST_LIMIT
    
    var siteId: String?
    
    var moreLoads = true
    
    func loadData(completion: @escaping ([Announcement]?, Error?) -> Void) {
        SakaiService.shared.getAllAnnouncements(offset: offset, limit: numToRequest, daysBack: daysBack, completion: { (announcementList, moreLoads) in
            self.moreLoads = moreLoads
            
            guard let list = announcementList else {
                completion(nil, nil)
                return
            }
            self.offset += list.count
            self.numToRequest += AnnouncementDataFetcher.REQUEST_LIMIT
            
            completion(announcementList, nil)
        }, siteId: siteId)
    }
    
    func resetOffset() {
        offset = 0
        numToRequest = AnnouncementDataFetcher.REQUEST_LIMIT
        moreLoads = true
    }
}
