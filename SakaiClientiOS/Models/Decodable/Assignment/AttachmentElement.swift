//
//  AttachmentElement.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/31/18.
//

import Foundation

struct AttachmentElement: Decodable {
    let name: String
    let url: String

    func toAttributedString() -> NSAttributedString {
        let attachmentString = NSMutableAttributedString(string: name)
        let range = NSRange(location: 0, length: name.count)
        attachmentString.addAttribute(.link, value: url, range: range)
        return attachmentString
    }
}
