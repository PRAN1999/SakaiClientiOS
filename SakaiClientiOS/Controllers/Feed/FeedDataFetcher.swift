//
//  FeedDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/19/18.
//

import ReusableSource

protocol FeedDataFetcher: DataFetcher {
    
    var offset: Int { get set }
    var numToRequest: Int { get set }
    var moreLoads: Bool { get set }
    
    func resetOffset()
}
