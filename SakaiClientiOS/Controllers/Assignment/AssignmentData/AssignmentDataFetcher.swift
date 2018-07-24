//
//  AssignmentDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/14/18.
//

import ReusableSource

class AssignmentDataFetcher: HideableDataFetcher {
    
    typealias T = [[[Assignment]]]
    
    func loadData(completion: @escaping ([[[Assignment]]]?) -> Void) {
        DataHandler.shared.getAllAssignmentsBySites { (res) in
            completion(res)
        }
    }
    
    
    func loadData(for section: Int, completion: @escaping ([[[Assignment]]]?) -> Void) {
        
    }
}
