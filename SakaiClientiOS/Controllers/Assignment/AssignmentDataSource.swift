//
//  AssignmentDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/10/18.
//

import UIKit

class AssignmentDataSource: NSObject, UICollectionViewDataSource {
    
    var assignments:[Assignment]!
    var numItems = 0
    
    var webviewDelegate: WebviewLoaderDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssignmentCell.reuseIdentifier, for: indexPath) as? AssignmentCell else {
            fatalError("Not an assignment cell")
        }
        let assignment:Assignment = self.assignments[indexPath.row]
        cell.titleLabel.setText(text:assignment.getTitle())
        cell.dueLabel.setText(text:assignment.getDueTimeString())
        cell.descLabel.attributedText = assignment.getAttributedInstructions()
        cell.webviewDelegate = webviewDelegate
        return cell
    }

    func loadData(list: [Assignment]) {
        self.assignments = list
        self.numItems = list.count
    }
}
