//
//  DataFetcher.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/11/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

public protocol DataFetcher {
    associatedtype T
    
    func loadData(completion: @escaping (T?) -> Void)
}
