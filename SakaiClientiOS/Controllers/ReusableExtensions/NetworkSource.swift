//
//  ReusableTableSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/13/18.
//

import ReusableSource

extension NetworkSource where Self: ReusableSource {
    func loadDataSourceWithoutCache(completion: @escaping () -> Void) {
        RequestManager.shared.resetCache()
        loadDataSource(completion: completion)
    }
}
