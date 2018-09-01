//
//  NetworkViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/29/18.
//

import UIKit
import ReusableSource

extension NetworkSourceDelegate where Self: UIViewController {
    func networkSourceWillBeginLoadingData<Source: NetworkSource>(_ networkSource: Source) -> (() -> Void)? {
        return self.addLoadingIndicator()
    }

    func networkSourceSuccessfullyLoadedData<Source: NetworkSource>(_ networkSource: Source?) {
        // No default implementation
    }
    
    func networkSourceFailedToLoadData<Source: NetworkSource>(_ networkSource: Source?, withError error: Error) {
        self.presentErrorAlert(error: error)
    }
}
