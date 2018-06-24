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
    
    var textViewDelegate: UITextViewDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssignmentCell.reuseIdentifier, for: indexPath) as? AssignmentCell else {
            fatalError("Not an assignment cell")
        }
        let assignment:Assignment = assignments[indexPath.row]
        cell.titleLabel.setText(text:assignment.getTitle())
        cell.dueLabel.setText(text:assignment.getDueTimeString())
        cell.descLabel.attributedText = assignment.getAttributedInstructions()
        cell.descLabel.delegate = textViewDelegate
        return cell
    }

    func loadData(list: [Assignment]) {
        assignments = list
        numItems = list.count
    }
}
