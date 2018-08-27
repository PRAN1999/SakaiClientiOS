//
//  SiteDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import Foundation
import ReusableSource

class SiteDataFetcher: DataFetcher {
    typealias T = [[Site]]
    
    func loadData(completion: @escaping ([[Site]]?, Error?) -> Void) {
        SakaiService.shared.getSites { siteList, err in
            completion(siteList, nil)
        }
    }
    
}
