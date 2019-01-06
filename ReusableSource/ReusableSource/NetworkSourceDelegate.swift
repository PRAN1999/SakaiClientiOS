//
//  NetworkSourceDelegate.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 8/29/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation
import UIKit

/// A delegate to respond to NetworkSource events, usually to configure
/// changes to the UI
public protocol NetworkSourceDelegate: class {

    /// Execute tasks before networkSource begins data load and returns
    /// callback to execute immediately after whether or not load is
    /// successful.
    ///
    /// Can be used to add and remove ActivityIndicator from view
    ///
    /// - Parameter networkSource: a NetworkSource implementation
    /// - Returns: a callback to execute immediately after data load
    func networkSourceWillBeginLoadingData<Source: NetworkSource>
        (_ networkSource: Source) -> (() -> Void)?

    /// Execute tasks when networkSource successfully loads data into data
    /// source
    ///
    /// - Parameter networkSource: a NetworkSource implementation
    func networkSourceSuccessfullyLoadedData<Source: NetworkSource>
        (_ networkSource: Source?)

    /// Execute tasks when networkSource encounters error on data load
    ///
    /// - Parameters:
    ///   - networkSource: a NetworkSource implementation
    ///   - error: the Error thrown when trying to fetch and parse data
    ///            from network request
    func networkSourceFailedToLoadData<Source: NetworkSource>
        (_ networkSource: Source?, withError error: Error)
}
