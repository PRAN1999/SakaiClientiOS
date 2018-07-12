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
}
