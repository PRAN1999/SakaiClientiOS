//
//  PageDelegate.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/25/18.
//

import Foundation
import UIKit

protocol PageDelegate: class {
    func pageController(_ pageController: PagesController, didMoveToIndex index: Int)

    //func pageControllerDidRotate(_ pageController: PagesController, at index: Int)
}
