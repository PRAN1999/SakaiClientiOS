//
//  AssignmentDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/14/18.
//

import ReusableSource

/// Fetch Assignments data for the Assignments tab
class AssignmentDataFetcher: HideableDataFetcher {
    
    typealias T = [[Assignment]]
    
    func loadData(for section: Int, completion: @escaping ([[Assignment]]?, Error?) -> Void) {
        /// Use the source of truth to retrieve which sites to request data for
        let sites = SakaiService.shared.termMap[section].1
        let group = DispatchGroup()
        var termAssignmentArray: [[Assignment]] = []
        var errors: [SakaiError] = []
        for site in sites {
            group.enter()
            let request = SakaiRequest<AssignmentCollection>(endpoint: .siteAssignments(site), method: .get)
            RequestManager.shared.makeEndpointRequest(request: request) { data, err in
                if let err = err {
                    errors.append(err)
                }
                if let data = data {
                    var arr = data.assignmentCollection
                    arr.sort { $0.dueDate > $1.dueDate }
                    termAssignmentArray.append(arr)
                }
                group.leave()
            }
        }
        group.notify(queue: .global(), work: .init(block: {
            var error: SakaiError? = SakaiError.dispatchGroupError(errors)
            if errors.count == 0 {
                error = nil
            }
            completion(termAssignmentArray, error)
        }))
    }
}
