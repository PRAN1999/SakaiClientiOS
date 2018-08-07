//
//  AssignmentCollectionSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import ReusableSource

class AssignmentCollectionDataSourceDelegate : ReusableCollectionDataSourceFlowDelegate<SingleSectionDataProvider<Assignment>, AssignmentCell> {

    var textViewDelegate = Delegated<Void, UITextViewDelegate>()
    
    init(collectionView: UICollectionView) {
        super.init(provider: SingleSectionDataProvider<Assignment>(), collectionView: collectionView)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size:CGSize = CGSize(width: collectionView.bounds.width / 2.25, height: collectionView.bounds.height)
        return size
    }
    
    override func configureBehavior(for cell: AssignmentCell, at indexPath: IndexPath) {
        cell.descLabel.delegate = textViewDelegate.call()
        cell.tapRecognizer.addTarget(self, action: #selector(handleIndexTap(sender:)))
    }
    
    @objc func handleIndexTap(sender: Any) {
        guard let recognizer = sender as? IndexRecognizer else {
            return
        }
        if let indexPath = recognizer.indexPath {
            collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
}
