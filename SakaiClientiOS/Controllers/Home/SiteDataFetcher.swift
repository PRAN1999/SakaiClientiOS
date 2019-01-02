//
//  SiteDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//
import ReusableSource

class SiteDataFetcher: DataFetcher {
    typealias T = [[Site]]

    private var cacheUpdateService: CacheUpdateService
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
                self?.cacheUpdateService.siteTermMap.updateValue(site.term, forKey: site.id)
                self?.cacheUpdateService.siteTitleMap.updateValue(site.title, forKey: site.id)
            }
            let sectionList = Term.splitByTerms(listToSort: siteList)
            // Split the site list by Term
            let listMap = sectionList.map {
                ($0[0].term, $0.map { $0.id })
            }
            listMap.forEach { list in
                if list.0.exists() {
                    self?.cacheUpdateService.termMap.append(list)
                }
            }
            completion(sectionList, nil)
        }
    }
    
}
