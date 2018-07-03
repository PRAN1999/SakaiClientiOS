//
//  AnnouncementDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/30/18.
//

import UIKit

class AnnouncementDataSource: NSObject, UICollectionViewDataSource {
    
    var numItems = 0
    var announcements:[Announcement] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnnouncementCell.reuseIdentifier, for: indexPath) as? AnnouncementCell else {
            fatalError("Not an AnnouncementCell")
        }
        
        return cell
    }
}
