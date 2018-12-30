//
//  SiteAssignmentDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/24/18.
//

import ReusableSource

class SiteAssignmentDataFetcher: DataFetcher {
    typealias T = [Assignment]
    
    let siteId: String
    
    init(siteId: String) {
        self.siteId = siteId
    }

    func loadData(completion: @escaping ([Assignment]?, Error?) -> Void) {
        let request = SakaiRequest<AssignmentCollection>(endpoint: .siteAssignments(siteId), method: .get)
        RequestManager.shared.makeEndpointRequest(request: request) { data, err in
            var arr = data?.assignmentCollection
            arr?.sort { $0.dueDate > $1.dueDate }
            completion(arr, err)
        }
    }
}
