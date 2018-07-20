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
    
    func loadData(completion: @escaping ([GradeItem]?) -> Void) {
        DataHandler.shared.getSiteGrades(siteId: siteId) { (res) in
            completion(res)
        }
    }
}
