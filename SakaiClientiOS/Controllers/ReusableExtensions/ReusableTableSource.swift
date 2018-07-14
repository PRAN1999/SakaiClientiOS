//
//  ReusableTableSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/13/18.
//

import ReusableSource

extension ReusableTableSource {
    func loadDataSourceWithoutCache(completion: @escaping () -> Void) {
        provider.resetValues()
        self.tableView.reloadData()
        fetcher.loadDataWithoutCache { (res) in
            guard let response = res else {
                completion()
                return
            }
            self.provider.loadItems(payload: response)
            self.tableView.reloadData()
            completion()
        }
    }
}
