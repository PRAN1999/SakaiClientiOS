//
//  HideableNetworkSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/23/18.
//

import ReusableSource

protocol HideableNetworkSource: NetworkSource where Self.Fetcher: HideableDataFetcher {

    func handleSectionLoad(forSection section: Int)

    func populateDataSource(with payload: Fetcher.T, forSection section: Int)

    func loadDataSource(for section: Int, completion: (() -> Void)?)
}

extension HideableNetworkSource {

    func loadDataSource() {
        let callback = self.delegate?.networkSource(willBeginLoadingDataSource: self)
        prepareDataSourceForLoad()
        loadDataSource(for: 0, completion: callback)
    }

    func loadDataSource(for section: Int, completion: (() -> Void)?) {
        fetcher.loadData(for: section) { [weak self] res, err in
            DispatchQueue.main.async {
                completion?()
                self?.handleSectionLoad(forSection: section)
                if err != nil {
                    self?.delegate?.networkSource(errorLoadingDataSource: self, withError: err!)
                }
                if let response = res {
                    self?.populateDataSource(with: response, forSection: section)
                    self?.delegate?.networkSource(successfullyLoadedDataSource: self)
                }
            }
        }
    }
}
