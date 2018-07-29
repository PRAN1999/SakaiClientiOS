//
//  NetworkSource.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/14/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

public protocol NetworkSource {
    
    associatedtype Fetcher : DataFetcher
    
    var fetcher : Fetcher { get }
    
    func loadDataSource(completion: @escaping () -> Void)
}

public extension NetworkSource where Self:ReusableSource, Self.Provider.V == Fetcher.T {
    func loadDataSource(completion: @escaping () -> Void) {
        resetValues()
        reloadData()
        fetcher.loadData(completion: { (res) in
            guard let response = res else {
                completion()
                return
            }
            DispatchQueue.main.async {
                self.loadItems(payload: response)
                self.reloadData()
                completion()
            }
        })
    }
}
