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

struct AssignmentElement: Decodable {
    let title: String
    let dueTimeString: String
    let dueTime: DueTime
    let instructions: String?
    let siteId: String
    let status: String
    let resubmissionAllowed: Bool
    let reference: String
    let maxPoints: String?
    let attachments: [AttachmentElement]?

    enum CodingKeys: String, CodingKey {
        case title, dueTimeString, dueTime, instructions
        case siteId = "context"
        case status
        case reference = "entityReference"
        case resubmissionAllowed = "allowResubmission"
        case maxPoints = "gradeScaleMaxPoints"
        case attachments
    }
}

struct DueTime: Decodable {
    let time: Date
}
