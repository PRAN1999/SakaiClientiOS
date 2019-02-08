//
//  AnnouncementDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import ReusableSource

/// Fetch Announcement Data and maintain offset and limit internally for
/// feed. Can optionally have a siteId set in order to fetch data for
/// a single Site's announcements
///
/// Retrieve Announcement feed data and maintain state so subsequent calls
/// to loadData retrieve the next section of the feed - in order to simulate
/// RSS feed
class AnnouncementDataFetcher: DataFetcher {
    
    private static let requestLimit = 35
    private static let announcementLimit = 100000
    private static let daysBack = 100000

    typealias T = [Announcement]

    private var offset = 0
    private(set) var moreLoads = true

    private var cachedResults: [Announcement]?
    private let networkService: NetworkService

    var siteId: String?

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func loadData(completion: @escaping ([Announcement]?, Error?) -> Void) {
        fetchData() { [weak self] announcementList, moreLoads, err in
            self?.moreLoads = moreLoads
            let res: [Announcement]
            if let list = announcementList {
                self?.offset += list.count
                res = list
            } else {
                res = []
            }

            completion(res, err)
        }
    }

    /// Fetches data in a stateful manner. Will parse cache if available
    /// and otherwise makes network request to retrieve all Announcement
    /// data
    ///
    /// The Sakai API is not built for retrieving Announcement data in a
    /// feed format. Instead it allows results to be fetched according
    /// to the maximum number of results and the number of days to
    /// travel back. Since there doesn't seem to be an enormous
    /// performance benefit to only requesting a few announcements at a
    /// time over requesting a huge amount, the network request is only
    /// made once and the results are cached. The most expensive
    /// operation with decoding Announcements is converting the html to
    /// attributedString so whenever a section of Announcements is
    /// fetched using loadData, only the Annoucements in that section
    /// will have the attributedContent set.
    ///
    /// See retriveAnnouncementSection for more details.
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

        var endpoint = SakaiEndpoint.announcements(AnnouncementDataFetcher.announcementLimit,
                                                   AnnouncementDataFetcher.daysBack)
        if let id = siteId {
            endpoint = .siteAnnouncements(id,
                                          AnnouncementDataFetcher.announcementLimit,
                                          AnnouncementDataFetcher.daysBack)
        }
        let request = SakaiRequest<AnnouncementCollection>(endpoint: endpoint, method: .get)

        networkService.makeEndpointRequest(request: request) { [weak self] data, err in
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
            // Most expensive operation
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
