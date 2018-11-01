//
//  HideableDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/22/18.
//

import ReusableSource

/// A DataFetcher designed to work with HideableNetworkSource by loading data for a specific section
protocol HideableDataFetcher: DataFetcher {

    /// Load data by Term for a specific section
    ///
    /// - Parameters:
    ///   - section: the section or Term to load data for
    ///   - completion: callback to execute with fetched data
    func loadData(for section: Int, completion: @escaping (T?, Error?) -> Void)
}

extension HideableDataFetcher {
    func loadData(completion: @escaping (T?, Error?) -> Void) {
        loadData(for: 0) { payload, err in
            completion(payload, err)
        }
    }
}
