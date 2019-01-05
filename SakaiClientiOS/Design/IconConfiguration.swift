//
//  IconConfiguration.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/3/19.
//

import Foundation

struct IconConfiguration {
    let icons: [SubjectCodeIcon]
}

extension IconConfiguration: Decodable {}

struct SubjectCodeIcon {
    let subjectCode: String
    let hex: String
}

extension SubjectCodeIcon: Decodable {
    enum CodingKeys: String, CodingKey {
        case subjectCode, hex = "iOS"
    }
}
