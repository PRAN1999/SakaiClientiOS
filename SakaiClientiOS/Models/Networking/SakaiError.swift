//
//  SakaiError.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/29/18.
//

import Foundation

/// An error type to handle errors with Sakai network requests or Sakai data parsing
///
/// - networkError: a error to represent an error with an HTTP request. Constructed with a message
///                 detailing the error
/// - parseError: a error that occurs during the decoding of JSON data retrieved from Sakai
/// - dispatchGroupError: a group of errors that occur when using a Dispatch Group to send out multiple requests
enum SakaiError: Error {
    case networkError(String, Int?)
    case parseError(String)
    indirect case dispatchGroupError([SakaiError])
}

// MARK: LocalizedError extension

// Provides default localizedDescription messages for each SakaiError type
extension SakaiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError(let message, _):
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
