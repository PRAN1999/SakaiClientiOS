//
//  Parsing.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/28/18.
//

import Foundation

extension String {
    /// Converts HTML string to a `NSAttributedString` with HTML markup
    var htmlAttributedString: NSAttributedString? {
        return try? NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }
}
