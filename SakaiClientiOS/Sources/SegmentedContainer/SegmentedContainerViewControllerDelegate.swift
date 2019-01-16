//
//  SegmentedContainerViewControllerDelegate.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/15/19.
//

import Foundation
import UIKit

@objc protocol SegmentedContainerViewControllerDelegate {
    @objc optional func segmentedContainer(_ segmentedContainer: SegmentedContainerViewController,
                                           willShowController controller: UIViewController,
                                           atIndex index: Int)

    @objc optional func segmentedContainer(_ segmentedContainer: SegmentedContainerViewController,
                                           willHideController controller: UIViewController,
                                           atIndex index: Int)
}
