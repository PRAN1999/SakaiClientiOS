//
//  SakaiException.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/29/18.
//

import Foundation
import SwiftyJSON

enum SakaiError: Error {
    case networkException(Int?, String?)
    case parseException(String)
}

extension SakaiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkException(let code, let message):
            return NSLocalizedString("Network Error with code \(code)", comment: "\(message)")
        case .parseException(let message):
            return NSLocalizedString("Parse Error", comment: message)
        }
    }
}
