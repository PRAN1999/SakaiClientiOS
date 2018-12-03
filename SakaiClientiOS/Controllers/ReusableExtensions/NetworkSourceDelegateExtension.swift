//
//  NetworkSourceDelegateExtension.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/29/18.
//

import UIKit
import ReusableSource

// MARK: - NetworkSourceDelegate conformance

// Any Loadable UIViewController adopting the NetworkSourceDelegate protocol
// will have a set of default implementations
extension NetworkSourceDelegate where Self: UIViewController, Self: LoadableController {
    func networkSourceWillBeginLoadingData<Source: NetworkSource>(_ networkSource: Source) -> (() -> Void)? {
        return addLoadingIndicator()
    }

    func networkSourceSuccessfullyLoadedData<Source: NetworkSource>(_ networkSource: Source?) {
        // No default implementation
    }
    
    func networkSourceFailedToLoadData<Source: NetworkSource>(_ networkSource: Source?, withError error: Error) {
        presentErrorAlert(error: error)
    }
}
