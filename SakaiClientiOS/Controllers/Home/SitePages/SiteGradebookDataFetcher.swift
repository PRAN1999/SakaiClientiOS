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
        SakaiService.shared.getSiteGrades(siteId: siteId) { res, err in
            completion(res, err)
        }
    }
}
