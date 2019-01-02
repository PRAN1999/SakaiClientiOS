//
//  SiteAssignmentDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/24/18.
//

import ReusableSource

class SiteAssignmentDataFetcher: DataFetcher {
    typealias T = [Assignment]
    
    private let siteId: String
    private let networkService: NetworkService
    
    init(siteId: String, networkService: NetworkService) {
        self.siteId = siteId
        self.networkService = networkService
    }

    func loadData(completion: @escaping ([Assignment]?, Error?) -> Void) {
        let request = SakaiRequest<AssignmentCollection>(endpoint: .siteAssignments(siteId), method: .get)
        networkService.makeEndpointRequest(request: request) { data, err in
            var arr = data?.assignmentCollection
            arr?.sort { $0.dueDate > $1.dueDate }
            completion(arr, err)
        }
    }
}
