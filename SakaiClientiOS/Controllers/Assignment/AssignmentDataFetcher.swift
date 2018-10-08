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
        SakaiService.shared.getTermAssignments(for: sites) { res, err in
            completion(res, err)
        }
    }
}
