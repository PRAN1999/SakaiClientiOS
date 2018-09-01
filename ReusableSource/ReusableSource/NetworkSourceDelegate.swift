//
//  NetworkManagerDelegate.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 8/29/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

import Foundation
import UIKit

public protocol NetworkSourceDelegate: class {
    func networkSourceWillBeginLoadingData<Source: NetworkSource>(_ networkSource: Source) -> (() -> ())?
    func networkSourceSuccessfullyLoadedData<Source: NetworkSource>(_ networkSource: Source?)
    func networkSourceFailedToLoadData<Source: NetworkSource>(_ networkSource: Source?, withError error: Error)
}
