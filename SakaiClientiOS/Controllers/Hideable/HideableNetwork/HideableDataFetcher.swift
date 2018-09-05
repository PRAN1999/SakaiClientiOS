//
//  HideableDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/22/18.
//

import ReusableSource

/// A DataFetcher designed to work with HideableNetworkSource by loading data for a specific section
protocol HideableDataFetcher: DataFetcher {
    func loadData(for section: Int, completion: @escaping (T?, Error?) -> Void)
}

extension HideableDataFetcher {
    func loadData(completion: @escaping (T?, Error?) -> Void) {
        loadData(for: 0) { payload, err in
            completion(payload, err)
        }
    }
}
