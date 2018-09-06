//
//  SiteAssignmentCollectionManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/24/18.
//

import ReusableSource

class SiteAssignmentCollectionManager: AssignmentCollectionManager, NetworkSource {
    weak var delegate: NetworkSourceDelegate?

    typealias Fetcher = SiteAssignmentDataFetcher
    
    let fetcher: SiteAssignmentDataFetcher
    
    init(collectionView: UICollectionView, siteId: String) {
        fetcher = SiteAssignmentDataFetcher(siteId: siteId)
        super.init(collectionView: collectionView)
    }
    
    override func setup() {
        super.setup()
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size:CGSize = CGSize(width: collectionView.bounds.width / 2.25, height: collectionView.frame.height / 2.8)
        return size
    }
}
