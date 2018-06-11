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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssignmentCell.reuseIdentifier, for: indexPath) as? AssignmentCell else {
            fatalError("Not an assignment cell")
        }
        cell.backgroundColor = UIColor.red
        let assignment:Assignment = self.assignments[indexPath.row]
        cell.titleLabel.text = assignment.getTitle()
        cell.dueLabel.text = assignment.getDueTimeString()
        return cell
    }

    func loadData(list: [Assignment]) {
        self.assignments = list
        self.numItems = list.count
        print(list)
        print(numItems)
    }
}
