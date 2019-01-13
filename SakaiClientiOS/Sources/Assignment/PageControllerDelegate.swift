//
//  PageDelegate.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/25/18.
//

import Foundation
import UIKit

/// In order to track Assignment paging in the forwarding collectionView,
/// the PageDelegate allows the implementer to respond to the paging event
/// of the PagesController
///
/// This is primarily used to sync the collection view in the previous
/// screen with the UIPageController, so the transition back occurs in
/// context
protocol PagesControllerDelegate: class {
    func pageController(_ pageController: PagesController, didMoveToIndex index: Int)
}
