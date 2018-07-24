//
//  HideableDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/22/18.
//

import ReusableSource

protocol HideableDataFetcher: DataFetcher {
    func loadData(for section: Int, completion: @escaping (T?) -> Void)
}

extension HideableDataFetcher {
    func loadData(completion: @escaping (T?) -> Void) {
        loadData(for: 0) { (payload) in
            completion(payload)
        }
    }
}
