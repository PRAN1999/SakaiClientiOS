//
//  SakaiException.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/29/18.
//

import Foundation

indirect enum SakaiError: Error {
    case networkError(String)
    case parseError(String)
    case dispatchGroupError([SakaiError])
}

extension SakaiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return NSLocalizedString("Network Error: \(message)", comment: "Network Error Description")
        case .parseError(let message):
            return NSLocalizedString("Parse Error: \(message)", comment: "Parse Error Description")
        case .dispatchGroupError(let errors):
            var message = "Error in one or more requests: \n\n"
            for error in errors {
                message += error.localizedDescription + "\n"
            }
            return NSLocalizedString(message, comment: "Dispatch Group Error Description")
        }
    }
}
