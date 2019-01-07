//
//  ResourceDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/29/18.
//

import ReusableSource

class ResourceDataFetcher: DataFetcher {
    typealias T = [ResourceNode]
    
    private let siteId: String
    private let networkService: NetworkService
    
    init(siteId: String, networkService: NetworkService) {
        self.siteId = siteId
        self.networkService = networkService
    }
    
    func loadData(completion: @escaping ([ResourceNode]?, Error?) -> Void) {
        let request = SakaiRequest<ResourceCollection>(
                endpoint: .siteResources(siteId),
                method: .get
        )
        networkService.makeEndpointRequest(request: request) { data, err in
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


