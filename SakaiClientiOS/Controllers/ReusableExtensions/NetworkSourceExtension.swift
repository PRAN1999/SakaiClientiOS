//
//  NetworkSourceExtension.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/13/18.
//

import ReusableSource

extension NetworkSource {
    /// Force a NetworkSource to load data from an endpoint without
    /// retrieving already cached results
    func loadDataSourceWithoutCache() {
        RequestManager.shared.resetCache()
        loadDataSource()
    }
}
