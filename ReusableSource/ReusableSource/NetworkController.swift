//
//  NetworkController.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/14/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import UIKit

public protocol NetworkController {
    associatedtype Source : NetworkSource, ReusableSource
    
    var networkSource: Source { get }
}
