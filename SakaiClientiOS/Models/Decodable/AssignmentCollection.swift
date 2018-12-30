//
//  RawAssignment.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/31/18.
//

import Foundation

struct AssignmentCollection: Decodable {
    let assignmentCollection: [Assignment]

    enum CodingKeys: String, CodingKey {
        case assignmentCollection = "assignment_collection"
    }
}
