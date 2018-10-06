//
//  DataFetcherExtension.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/13/18.
//

import ReusableSource

extension DataFetcher {
    /// Before fetching data, flush cookies and cache
    ///
    /// - Parameter completion: callback to execute
    func loadDataWithoutCache(completion: @escaping (T?, Error?) -> Void) {
        RequestManager.shared.resetCache()
        loadData(completion: completion)
    }
}
