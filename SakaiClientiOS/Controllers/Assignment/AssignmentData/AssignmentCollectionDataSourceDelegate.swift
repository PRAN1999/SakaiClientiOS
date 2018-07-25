//
//  AssignmentCollectionSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import ReusableSource

class AssignmentCollectionDataSourceDelegate : ReusableCollectionDataSourceFlowDelegate<SingleSectionDataProvider<Assignment>, AssignmentCell> {
    
    var controller: UIViewController?
    
    init(collectionView: UICollectionView) {
        super.init(provider: SingleSectionDataProvider<Assignment>(), collectionView: collectionView)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size:CGSize = CGSize(width: collectionView.bounds.width / 2.25, height: collectionView.bounds.height)
        return size
    }
    
    override func configureBehavior(for cell: AssignmentCell, at indexPath: IndexPath) {
        cell.descLabel.delegate = controller
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        let storyboard = UIStoryboard(name: "AssignmentView", bundle: nil)
        let pages = storyboard.instantiateViewController(withIdentifier: "pagedController") as! PagesController
        pages.setAssignments(assignments: provider.items, start: indexPath.row)
        controller?.navigationController?.pushViewController(pages, animated: true)
    }
}
