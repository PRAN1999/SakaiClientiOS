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
    var collectionViewDelegate: UICollectionViewDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssignmentCell.reuseIdentifier, for: indexPath) as? AssignmentCell else {
            fatalError("Not an assignment cell")
        }
        let assignment:Assignment = assignments[indexPath.row]
//        cell.titleLabel.setText(text:assignment.title)
//        cell.dueLabel.setText(text:"Due: \(assignment.dueTimeString)")
        cell.descLabel.attributedText = assignment.attributedInstructions
        cell.descLabel.delegate = textViewDelegate
        
//      cell.tapRecognizer.collectionView = collectionView
        cell.tapRecognizer.indexPath = indexPath
//        cell.tapRecognizer.addTarget(collectionViewDelegate as Any, action: #selector(AssignmentController.handleIndexTap(sender:)))
        return cell
    }

    func loadData(list: [Assignment]) {
        assignments = list
        numItems = list.count
    }
}
