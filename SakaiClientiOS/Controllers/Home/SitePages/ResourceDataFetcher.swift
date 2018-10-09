//
//  ResourceDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/29/18.
//

import ReusableSource

class ResourceDataFetcher: DataFetcher {
    
    let siteId: String
    
    init(siteId: String) {
        self.siteId = siteId
    }
    
    typealias T = [ResourceNode]
    
    func loadData(completion: @escaping ([ResourceNode]?, Error?) -> Void) {
        SakaiService.shared.getSiteResources(for: siteId) { res, err in
            completion(res, err)
        }
    }
}


