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
    let subjectCode: Int
    let iconInt: String
}

extension SubjectCodeIcon: Decodable {}
