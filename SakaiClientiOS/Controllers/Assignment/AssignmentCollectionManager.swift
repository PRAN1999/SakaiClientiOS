//
//  AssignmentCollectionManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import ReusableSource

/// Manages a collection of Assignments within a tableView cell. Can be scrolled horizontally
class AssignmentCollectionManager: ReusableCollectionManager<SingleSectionDataProvider<Assignment>, AssignmentCell> {

    var textViewDelegate = Delegated<Void, UITextViewDelegate>()

    var flipForTransitionIndex: Int?
    
    convenience init(collectionView: UICollectionView) {
        self.init(provider: SingleSectionDataProvider<Assignment>(), collectionView: collectionView)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size:CGSize = CGSize(width: collectionView.bounds.width / 2.25, height: collectionView.bounds.height)
        return size
    }
    
    override func configureBehavior(for cell: AssignmentCell, at indexPath: IndexPath) {
        if flipForTransitionIndex == indexPath.row {
            cell.flip(withDirection: .toBack, animated: false) {}
            flipForTransitionIndex = nil
        }
        cell.descLabel.delegate = textViewDelegate.call()
        cell.tapRecognizer.addTarget(self, action: #selector(handleIndexTap(sender:)))
        cell.pageViewTap.addTarget(self, action: #selector(handleIndexTap(sender:)))
    }
    
    /// Since textViews do not natively register taps, a custom recognizer was added to record
    /// taps on the textView within the UICollectionViewCell and the indexPath of the cell that
    /// was tapped.
    ///
    /// - Parameter sender: the custom tap recognizer added to an Assignment cell
    @objc private func handleIndexTap(sender: Any) {
        guard let recognizer = sender as? IndexRecognizer else {
            return
        }
        if let indexPath = recognizer.indexPath {
            collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
}
