//
//  SiteDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//
import ReusableSource

class SiteDataFetcher: DataFetcher {
    typealias T = [[Site]]
    
    func loadData(completion: @escaping ([[Site]]?, Error?) -> Void) {
        let request = SakaiRequest<SiteCollection>(endpoint: .sites, method: .get)
        RequestManager.shared.makeEndpointRequest(request: request) { data, err in
            guard err == nil, let data = data else {
                completion(nil, err)
                return
            }

            let siteList = data.siteCollection
            siteList.forEach { site in
                SakaiService.shared.siteTermMap.updateValue(site.term, forKey: site.id)
                SakaiService.shared.siteTitleMap.updateValue(site.title, forKey: site.id)
            }
            let sectionList = Term.splitByTerms(listToSort: siteList)
            // Split the site list by Term
            let listMap = sectionList.map {
                ($0[0].term, $0.map { $0.id })
            }
            for item in listMap {
                if item.0.exists() {
                    SakaiService.shared.termMap.append(item)
                }
            }
            completion(sectionList, nil)
        }
    }
    
}
