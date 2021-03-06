//
//  AttachmentElement.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/31/18.
//

import Foundation

/// A content attachment to an Announcement or an Assignment
struct AttachmentElement {
    let name: String
    let url: String

    func toAttributedString() -> NSAttributedString {
        let attachmentString = NSMutableAttributedString(string: name)
        let range = NSRange(location: 0, length: name.count)
        attachmentString.addAttribute(.link, value: url, range: range)
        return attachmentString
    }
}

extension AttachmentElement: Decodable {}
