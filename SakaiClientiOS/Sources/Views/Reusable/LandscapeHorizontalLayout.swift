//
//  LandscapeHorizontalLayout.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/6/19.
//

import UIKit

/// A CollectionViewLayout to scroll horizontally
class LandscapeHorizontalLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        if UIDevice.current.orientation == .landscapeRight ||
            UIDevice.current.orientation == .landscapeLeft {
            scrollDirection = .horizontal
        } else {
            scrollDirection = .vertical
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if UIDevice.current.orientation == .landscapeRight ||
            UIDevice.current.orientation == .landscapeLeft {
            scrollDirection = .horizontal
        } else {
            scrollDirection = .vertical
        }
        return true
    }
}
