//
//  SiteDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import Foundation

class SiteDataFetcher: DataFetcher {
    
    typealias T = [[Site]]
    
    func loadData(completion: @escaping ([[Site]]?) -> Void) {
        DataHandler.shared.getSites { siteList in
            completion(siteList)
        }
    }
    
}
