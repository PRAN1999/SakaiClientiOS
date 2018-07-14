//
//  NetworkSource.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/14/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

public protocol NetworkSource {
    
    associatedtype Provider: DataProvider
    associatedtype Fetcher : DataFetcher where Provider.V == Fetcher.T
    
    var fetcher : Fetcher { get }
}

public extension NetworkSource where Self:ReusableSource {
    func loadDataSource(completion: @escaping () -> Void) {
        provider.resetValues()
        reloadData()
        fetcher.loadData { (res) in
            guard let response = res else {
                completion()
                return
            }
            self.provider.loadItems(payload: response)
            self.reloadData()
            completion()
        }
    }
}
