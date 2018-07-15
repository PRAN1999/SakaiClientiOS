//
//  AssignmentDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/14/18.
//

import ReusableSource

class AssignmentDataFetcher: DataFetcher {
    typealias T = [[[Assignment]]]
    
    func loadData(completion: @escaping ([[[Assignment]]]?) -> Void) {
        DataHandler.shared.getAllAssignmentsBySites { (res) in
            completion(res)
        }
    }
}
