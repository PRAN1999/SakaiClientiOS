//
//  ResourceDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/29/18.
//

import ReusableSource

/// Fetch and construct ResourceTree for a Site
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

            // Sakai's resource tree is represented as a flattened tree in
            // JSON data so it needs to be mapped back to an actual Tree
            // structure in memory using the ResourceNode.
            let resourceCollection = data.contentCollection
            let tree = ResourceNode(data: resourceCollection)
            completion(tree.children, err)
        }
    }
}


