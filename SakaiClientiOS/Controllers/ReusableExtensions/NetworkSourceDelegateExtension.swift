//
//  NetworkViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/29/18.
//

import UIKit
import ReusableSource

extension NetworkSourceDelegate where Self: UIViewController {
    func networkSource<Source>(willBeginLoadingDataSource networkSource: Source) -> (() -> ())? where Source : NetworkSource {
        return self.addLoadingIndicator()
    }

    func networkSource<Source>(successfullyLoadedDataSource networkSource: Source?) where Source : NetworkSource {
        // No default implementation
    }

    func networkSource<Source>(errorLoadingDataSource networkSource: Source?, withError error: Error) where Source : NetworkSource {
        self.presentErrorAlert(error: error)
    }
}
