//
//  ReusableController.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/14/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation

public protocol ReusableController {
    associatedtype Source: ReusableSource
    
    var reusableSource: Source { get }
}
