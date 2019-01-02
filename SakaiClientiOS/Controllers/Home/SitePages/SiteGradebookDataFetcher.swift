//
//  SiteGradebookDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/18/18.
//

import ReusableSource

class SiteGradebookDataFetcher: DataFetcher {
    typealias T = [GradeItem]
    
    private let siteId: String
    private let networkService: NetworkService
    
    init(siteId: String, networkService: NetworkService) {
        self.siteId = siteId
        self.networkService = networkService
    }
    
    func loadData(completion: @escaping ([GradeItem]?, Error?) -> Void) {
        let request = SakaiRequest<SiteGradeItems>(endpoint: .siteGradebook(siteId), method: .get)
        networkService.makeEndpointRequest(request: request) { data, err in
            completion(data?.gradeItems, err)
        }
    }
}
