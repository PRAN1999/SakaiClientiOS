//
//  DataFetcher.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/11/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

/// An asynchronous data loader for a generic payload type
public protocol DataFetcher {
    
    /// The payload type for the data fetcher
    associatedtype T
    
    /// Asynchronously load data and execute callback with payload of type T.
    ///
    /// - Parameter completion: The callback function to execute with payload
    func loadData(completion: @escaping (T?, Error?) -> Void)
}
