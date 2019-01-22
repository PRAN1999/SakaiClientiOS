//
//  BundleExtension.swift
//  SakaiClientiOSTests
//
//  Created by Pranay Neelagiri on 1/20/19.
//

import Foundation
import XCTest

extension Bundle {
    func data(forResource name: String?, ofType ext: String?) -> Data? {
        guard let filePath = path(forResource: name, ofType: ext) else {
            XCTFail("Resource \(name).\(ext) not found")
            return nil
        }
        let fileURL = URL(fileURLWithPath: filePath)

        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch let err {
            XCTFail(err.localizedDescription)
            return nil
        }
    }
}
