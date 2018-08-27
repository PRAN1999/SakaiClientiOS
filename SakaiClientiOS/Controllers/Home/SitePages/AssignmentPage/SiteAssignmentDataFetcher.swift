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
        SakaiService.shared.getSiteAssignments(for: siteId) { (res) in
            completion(res, nil)
        }
    }
}
