//
//  SiteDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//
import ReusableSource

/// A DataLoader to load Site data for the user and update the source of
/// truth for all future requests. It also constructs and updates the global
/// Term map. See SakaiService and HideableNetworkSource for more info.
class SiteDataFetcher: DataFetcher {
    typealias T = [[Site]]

    private let cacheUpdateService: CacheUpdateService
    private let networkService: NetworkService

    init(cacheUpdateService: CacheUpdateService,
         networkService: NetworkService) {
        self.cacheUpdateService = cacheUpdateService
        self.networkService = networkService
    }
    
    func loadData(completion: @escaping ([[Site]]?, Error?) -> Void) {
        let request = SakaiRequest<SiteCollection>(endpoint: .sites,
                                                   method: .get)
        networkService.makeEndpointRequest(request: request) { [weak self] data, err in
            guard err == nil, let data = data else {
                completion(nil, err)
                return
            }

            let siteList = data.siteCollection
            siteList.forEach { site in
                self?.cacheUpdateService.updateSiteTerm(siteId: site.id, term: site.term)
                self?.cacheUpdateService.updateSiteTitle(siteId: site.id, title: site.title)
                if let code = site.subjectCode {
                    self?.cacheUpdateService.updateSiteSubjectCode(
                        siteId: site.id,
                        subjectCode: code
                    )
                }
                if let page = site.pages.first(where: { page -> Bool in page.pageType == .assignments }) {
                    self?.cacheUpdateService.setAssignmentToolUrl(url: page.url, siteId: page.siteId)
                }
            }
            // Split the site list by Term. Since each Site has a Term, the resulting
            // 2D-array is guaranteed to not have any empty sub-arrays
            let sectionList = Term.splitByTerms(listToSort: siteList)
            let listMap = sectionList.map {
                ($0[0].term, $0.map { $0.id })
            }
            listMap.forEach { list in
                if list.0.exists() {
                    // Only insert Terms that existed on Rutgers academic
                    // schedule into the global Term map. I.e. the General
                    // Term for 'CAC Residents' is not a Term that actually
                    // exists.
                    self?.cacheUpdateService.appendTermMap(map: list)
                }
            }
            completion(sectionList, nil)
        }
    }
    
}
