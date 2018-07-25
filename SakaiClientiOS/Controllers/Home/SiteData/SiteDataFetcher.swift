//
//  SiteDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import Foundation
import ReusableSource

class SiteDataFetcher: HideableDataFetcher {
    
    typealias T = [[Site]]
    
    func loadData(completion: @escaping ([[Site]]?) -> Void) {
        SakaiService.shared.getSites { siteList in
            completion(siteList)
        }
    }
    
    func loadData(for section: Int, completion: @escaping ([[Site]]?) -> Void) {
        
    }
    
}
