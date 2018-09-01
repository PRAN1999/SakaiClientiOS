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
        SakaiService.shared.getAllAnnouncements(offset: offset, limit: numToRequest, daysBack: daysBack, siteId: siteId, completion: { [weak self] announcementList, moreLoads, err in
            self?.moreLoads = moreLoads

            if let list = announcementList {
                self?.offset += list.count
                self?.numToRequest += AnnouncementDataFetcher.REQUEST_LIMIT
            }
            
            completion(announcementList, err)
        })
    }
    
    func resetOffset() {
        offset = 0
        numToRequest = AnnouncementDataFetcher.REQUEST_LIMIT
        moreLoads = true
    }
}
