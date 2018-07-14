//
//  DataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/13/18.
//

import Foundation
import ReusableSource

extension DataFetcher {
    func loadDataWithoutCache(completion: @escaping (T?) -> Void) {
        RequestManager.shared.resetCache()
        loadData(completion: completion)
    }
}
