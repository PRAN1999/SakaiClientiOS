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
        let request = SakaiRequest<ResourceCollection>(endpoint: .siteResources(siteId), method: .get)
        RequestManager.shared.makeEndpointRequest(request: request) { data, err in
            guard err == nil, let data = data else {
                completion(nil, err)
                return
            }

            let resourceCollection = data.contentCollection
            let tree = ResourceNode(data: resourceCollection)
            completion(tree.children, err)
        }
    }
}


