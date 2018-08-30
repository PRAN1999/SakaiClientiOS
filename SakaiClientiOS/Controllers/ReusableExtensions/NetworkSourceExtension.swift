//
//  NetworkSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/13/18.
//

import ReusableSource

extension NetworkSource {
    func loadDataSourceWithoutCache() {
        RequestManager.shared.resetCache()
        loadDataSource()
    }
}
