//
//  AssignmentCollectionManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import ReusableSource

/// Manages a collection of Assignments within a tableView cell. Can be scrolled horizontally
class AssignmentCollectionManager: ReusableCollectionManager<SingleSectionDataProvider<Assignment>, AssignmentCell> {

    weak var textViewDelegate: UITextViewDelegate?

    private(set) var selectedCell: AssignmentCell?
    private(set) var selectedCellFrame: CGRect?
    private var transitionIndex: Int?

    var scrollPosition: UICollectionView.ScrollPosition {
        return .centeredHorizontally
    }
    
    convenience init(collectionView: UICollectionView) {
        self.init(provider: SingleSectionDataProvider<Assignment>(), collectionView: collectionView)
    }

    override func setup() {
        super.setup()
        emptyView.backgroundColor = Palette.main.primaryBackgroundColor
        emptyView.textColor = Palette.main.secondaryTextColor
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = min(collectionView.bounds.width / 2.25, AssignmentCell.cellWidth)
        let size: CGSize = CGSize(width: width, height: AssignmentCell.cellHeight)
        return size
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as? AssignmentCell
        selectedCellFrame = selectedCell?.frame
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    override func configureBehavior(for cell: AssignmentCell, at indexPath: IndexPath) {
        cell.descLabel.delegate = textViewDelegate
        cell.tapRecognizer.addTarget(self, action: #selector(handleIndexTap(sender:)))
        cell.pageViewTap.addTarget(self, action: #selector(handleIndexTap(sender:)))
    }
    
    /// Since textViews do not natively register taps, a custom recognizer
    /// was added to record taps on the textView within the Cell and the
    /// indexPath of the cell that was tapped.
    ///
    /// - Parameter sender: the custom tap recognizer added to an Assignment
    ///                     cell
    @objc private func handleIndexTap(sender: Any) {
        guard let recognizer = sender as? IndexRecognizer else {
            return
        }
        if let indexPath = recognizer.indexPath {
            collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }

    func flipIfNecessary() {
        if let cell = selectedCell {
            cell.flip(withDirection: .toFront, animated: true, completion: {})
            setSelectionsNil()
            return
        }
        guard
            let index = transitionIndex,
            let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? AssignmentCell
            else {
                setSelectionsNil()
                return
        }

        cell.flip(withDirection: .toFront, animated: true, completion: {})
        setSelectionsNil()
    }

    func setSelectionsNil() {
        selectedCellFrame = nil
        selectedCell = nil
        transitionIndex = nil
    }
}

// MARK: PageDelegate Extension

extension AssignmentCollectionManager: AssignmentPagesViewControllerDelegate {

    func pageController(_ pageController: AssignmentPagesViewController, didMoveToIndex index: Int) {
        selectedCell?.flip(withDirection: .toFront, animated: false, completion: {})
        selectedCell = nil
        guard index < provider.items.count && index >= 0 else {
            return
        }

        let indexPath = IndexPath(row: index, section: 0)
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        selectedCellFrame = attributes?.frame
        transitionIndex = index
        
        collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
    }
}
