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
    func networkSource<Source: NetworkSource>(willBeginLoadingDataSource networkSource: Source) -> (() -> ())?
    func networkSource<Source: NetworkSource>(successfullyLoadedDataSource networkSource: Source?)
    func networkSource<Source: NetworkSource>(errorLoadingDataSource networkSource: Source?, withError error: Error?)
}
