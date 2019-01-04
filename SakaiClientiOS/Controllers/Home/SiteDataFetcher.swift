//
//  SiteDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//
import ReusableSource

class SiteDataFetcher: DataFetcher {
    typealias T = [[Site]]

    private let cacheUpdateService: CacheUpdateService
    private let networkService: NetworkService

    init(cacheUpdateService: CacheUpdateService, networkService: NetworkService) {
        self.cacheUpdateService = cacheUpdateService
        self.networkService = networkService
    }
    
    func loadData(completion: @escaping ([[Site]]?, Error?) -> Void) {
        let request = SakaiRequest<SiteCollection>(endpoint: .sites, method: .get)
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
                    self?.cacheUpdateService.updateSiteSubjectCode(siteId: site.id, subjectCode: code)
                }
            }
            let sectionList = Term.splitByTerms(listToSort: siteList)
            // Split the site list by Term
            let listMap = sectionList.map {
                ($0[0].term, $0.map { $0.id })
            }
            listMap.forEach { list in
                if list.0.exists() {
                    self?.cacheUpdateService.appendTermMap(map: list)
                }
            }
            completion(sectionList, nil)
        }
    }
    
}
