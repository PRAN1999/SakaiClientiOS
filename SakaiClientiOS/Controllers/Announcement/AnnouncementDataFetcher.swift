//
//  AnnouncementDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import ReusableSource

class AnnouncementDataFetcher: DataFetcher {
    
    private static let requestLimit = 35
    private static let announcementLimit = 100000
    private static let daysBack = 100000

    typealias T = [Announcement]

    private var offset = 0
    private(set) var moreLoads = true
    private var cachedResults: [Announcement]?

    var siteId: String?
    
    func loadData(completion: @escaping ([Announcement]?, Error?) -> Void) {
        fetchData() { [weak self] announcementList, moreLoads, err in
            self?.moreLoads = moreLoads
            if let list = announcementList {
                self?.offset += list.count
            }

            completion(announcementList, err)
        }
    }

    private func fetchData(completion: @escaping ([Announcement]?, Bool, SakaiError?) -> Void) {
        let limit = AnnouncementDataFetcher.requestLimit
        let offset = self.offset

        if let list = cachedResults {
            let announcementList = retrieveAnnouncementSection(list: list, offset: offset, limit: limit)
            if announcementList == nil {
                completion(nil, false, nil)
            } else {
                completion(announcementList, true, nil)
            }
            return
        }

        var endpoint = SakaiEndpoint.announcements(AnnouncementDataFetcher.announcementLimit, AnnouncementDataFetcher.daysBack)
        if let id = siteId {
            endpoint = .siteAnnouncements(id, AnnouncementDataFetcher.announcementLimit, AnnouncementDataFetcher.daysBack)
        }
        let request = SakaiRequest<AnnouncementCollection>(endpoint: endpoint, method: .get)

        RequestManager.shared.makeEndpointRequest(request: request) { [weak self] data, err in
            guard err == nil, let data = data else {
                completion(nil, false, err)
                return
            }

            let collection = data.announcementCollection
            self?.cachedResults = data.announcementCollection

            let announcementList = self?.retrieveAnnouncementSection(list: collection, offset: offset, limit: limit)

            if announcementList == nil {
                completion(nil, false, nil)
            } else {
                completion(announcementList, true, nil)
            }
        }
    }

    private func retrieveAnnouncementSection(list: [Announcement], offset: Int, limit: Int) -> [Announcement]? {
        if offset >= list.count {
            return nil
        }
        var announcements = list
        var announcementList: [Announcement] = []
        var start = offset
        var count = 0
        while count < limit && start < announcements.count {
            announcements[start].setAttributedContent()
            announcementList.append(announcements[start])
            start += 1
            count += 1
        }
        return announcementList
    }
    
    func resetOffset() {
        cachedResults = nil
        offset = 0
        moreLoads = true
    }
}
