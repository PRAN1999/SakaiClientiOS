//
//  DataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import Foundation

public protocol DataFetcher {
    associatedtype T
    
    func loadData(completion: @escaping (T?) -> Void)
    
    func loadDataWithoutCache(completion: @escaping (T?) -> Void)
}

extension DataFetcher {
    func loadDataWithoutCache(completion: @escaping (T?) -> Void) {
        RequestManager.shared.resetCache()
        loadData(completion: completion)
    }
}
