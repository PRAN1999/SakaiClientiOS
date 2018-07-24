//
//  HideableNetworkSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/23/18.
//

import ReusableSource

protocol HideableNetworkSource: NetworkSource where Self.Fetcher: HideableDataFetcher, Self.Provider: HideableNetworkDataProvider {
    
}

extension HideableNetworkSource where Self:ReusableSource {
    func loadDataSource(completion: @escaping () -> Void) {
        resetValues()
        reloadData()
        loadDataSource(for: 0) {
            completion()
        }
    }
    
    func loadDataSource(for section:Int, completion: @escaping () -> Void) {
        fetcher.loadData(for: section) { (res) in
            DispatchQueue.main.async {
                self.provider.hasLoaded[section] = true
                self.provider.isHidden[section] = false
                guard let payload = res else {
                    completion()
                    return
                }
                self.provider.loadItems(payload: payload, for: section)
                self.reloadData(for: section)
                completion()
            }
        }
    }
}
