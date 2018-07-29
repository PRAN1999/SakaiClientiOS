//
//  HideableNetworkSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/23/18.
//

import ReusableSource

protocol HideableNetworkSource: NetworkSource where Self.Fetcher: HideableDataFetcher {
    func loadDataSource(for section:Int, completion: @escaping () -> Void)
}
