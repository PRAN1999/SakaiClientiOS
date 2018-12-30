//
//  SiteGradebookDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/18/18.
//

import ReusableSource

class SiteGradebookDataFetcher: DataFetcher {
    typealias T = [GradeItem]
    
    let siteId: String
    
    init(siteId: String) {
        self.siteId = siteId
    }
    
    func loadData(completion: @escaping ([GradeItem]?, Error?) -> Void) {
        let request = SakaiRequest<SiteGradeItems>(endpoint: .siteGradebook(siteId), method: .get)
        RequestManager.shared.makeEndpointRequest(request: request) { data, err in
            completion(data?.gradeItems, err)
        }
    }
}
