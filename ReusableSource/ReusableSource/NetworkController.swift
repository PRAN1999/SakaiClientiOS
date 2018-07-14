//
//  ReusableController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/12/18.
//

import UIKit

public protocol NetworkController {
    associatedtype Source : NetworkSource
    
    var networkSource: Source { get }
}
