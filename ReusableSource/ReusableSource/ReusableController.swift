//
//  ReusableController.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/14/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

/// A controller that manages a ReusableSource implementation
public protocol ReusableController {
    
    /// An associated type that implements ReusableSource
    associatedtype Source: ReusableSource
    var reusableSource: Source { get }
    
    
}
