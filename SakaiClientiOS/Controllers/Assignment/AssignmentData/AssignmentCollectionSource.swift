//
//  AssignmentCollectionSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import ReusableSource

class AssignmentCollectionSource : ReusableCollectionDataSourceFlowDelegate<AssignmentCollectionDataProvider, AssignmentCell> {
    
    var controller: AssignmentController?
    var siteId: String?
    
    convenience init(collectionView: UICollectionView) {
        self.init(provider: AssignmentCollectionDataProvider(), collectionView: collectionView)
    }
    
    required init(provider: Provider, collectionView: UICollectionView) {
        super.init(provider: provider, collectionView: collectionView)
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
        let pages = storyboard.instantiateViewController(withIdentifier: "pagedController") as! PagedAssignmentController
        pages.setAssignments(assignments: provider.assignments, start: indexPath.row)
        controller?.navigationController?.pushViewController(pages, animated: true)
    }
}
