//
//  SiteAssignmentCollectionManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/24/18.
//

import ReusableSource

/// Manage Assignment Collection for a specific Site
class SiteAssignmentCollectionManager: AssignmentCollectionManager, NetworkSource {
    typealias Fetcher = SiteAssignmentDataFetcher
    
    let fetcher: SiteAssignmentDataFetcher
    weak var delegate: NetworkSourceDelegate?

    override var scrollPosition: UICollectionView.ScrollPosition {
        return .centeredVertically
    }
    
    convenience init(collectionView: UICollectionView, siteId: String) {
        let provider = SingleSectionDataProvider<Assignment>()
        let fetcher = SiteAssignmentDataFetcher(siteId: siteId,
                                                networkService: RequestManager.shared)
        self.init(provider: provider, fetcher: fetcher, collectionView: collectionView)
    }

    init(provider: Provider, fetcher: Fetcher, collectionView: UICollectionView) {
        self.fetcher = fetcher
        super.init(provider: provider, collectionView: collectionView)
    }
    
    override func setup() {
        super.setup()
        collectionView.backgroundColor = Palette.main.primaryBackgroundColor
        collectionView.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.indicatorStyle = Palette.main.scrollViewIndicatorStyle
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let height: CGFloat = AssignmentCell.cellHeight
        let width: CGFloat = min(collectionView.bounds.width / 2.25, AssignmentCell.cellWidth)
        let size: CGSize = CGSize(width: width, height: height)
        return size
    }

    override func isEmpty() -> Bool {
        return provider.items.count == 0
    }
}
