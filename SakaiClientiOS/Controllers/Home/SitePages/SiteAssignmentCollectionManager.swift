//
//  SiteAssignmentCollectionManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/24/18.
//

import ReusableSource

class SiteAssignmentCollectionManager: AssignmentCollectionManager, NetworkSource {
    typealias Fetcher = SiteAssignmentDataFetcher
    
    let fetcher: SiteAssignmentDataFetcher
    weak var delegate: NetworkSourceDelegate?

    var selectedCell: AssignmentCell?
    var selectedCellFrame: CGRect?
    
    convenience init(collectionView: UICollectionView, siteId: String) {
        let provider = SingleSectionDataProvider<Assignment>()
        let fetcher = SiteAssignmentDataFetcher(siteId: siteId)
        self.init(provider: provider, fetcher: fetcher, collectionView: collectionView)
    }

    init(provider: Provider, fetcher: Fetcher, collectionView: UICollectionView) {
        self.fetcher = fetcher
        super.init(provider: provider, collectionView: collectionView)
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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as? AssignmentCell
        selectedCellFrame = selectedCell?.frame
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}

extension SiteAssignmentCollectionManager: PageDelegate {
    func pageController(_ pageController: PagesController, didMoveToIndex index: Int) {
        selectedCell?.flip(withDirection: .toFront, animated: false, completion: {})
        selectedCell = nil
        let indexPath = IndexPath(row: index, section: 0)
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        selectedCellFrame = attributes?.frame
        flipForTransitionIndex = index
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
    }

    func flipIfNecessary() {
        if let cell = selectedCell {
            cell.flip {}
            return
        }
        guard
            let index = flipForTransitionIndex,
            let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? AssignmentCell
            else {
            return
        }

        cell.flip(withDirection: .toFront, animated: true, completion: {})
    }
}
