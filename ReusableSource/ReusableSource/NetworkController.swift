//
//  NetworkController.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/14/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import UIKit

/// A controller that manages a NetworkSource implementation
public protocol NetworkController {
    
    /// An associated type that implements NetworkSource
    associatedtype Source : NetworkSource
    var networkSource: Source { get }
    
    /// Loads the networkSource and executes a callback
    ///
    /// Will often use networkSource loadDataSource method and will layer callbacks
    ///
    /// - Parameter completion: Callback to execute once networkSource has loaded
    func loadController(completion: @escaping () -> Void)
}
