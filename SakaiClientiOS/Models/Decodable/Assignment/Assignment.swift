//
//  Assignment.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/10/18.
//

import Foundation

/// The model for an Assignment item
struct Assignment: Decodable, TermSortable, SiteSortable {
    let title: String
    let dueTimeString: String
    let dueDate: Date
    let instructions: String?
    let attributedInstructions: NSAttributedString?
    let term: Term
    let siteId: String
    let siteTitle: String?
    let status: String?
    let maxPoints: String?
    let currentGrade: String?
    let resubmissionAllowed: Bool?
    let attachments: [AttachmentElement]?
    let siteURL: String?

    init(from decoder: Decoder) throws {
        let assignmentElement = try AssignmentElement(from: decoder)
        self.title = assignmentElement.title
        self.dueTimeString = assignmentElement.dueTimeString
        self.dueDate = assignmentElement.dueTime.time
        self.instructions = assignmentElement.instructions
        self.attributedInstructions  = instructions?.htmlAttributedString
        self.siteId = assignmentElement.siteId
        self.siteTitle = SakaiService.shared.siteTitleMap[siteId]
        self.status = assignmentElement.status
        self.resubmissionAllowed = assignmentElement.resubmissionAllowed
        guard let assignmentsUrl = SakaiService.shared.siteAssignmentToolMap[siteId] else {
            throw SakaiError.parseError("Could not find associated Assignment page for Site")
        }
        self.siteURL = assignmentsUrl + "?assignmentReference=\(assignmentElement.reference)&sakai_action=doView_submission"
        self.maxPoints = assignmentElement.maxPoints
        self.currentGrade = nil
        self.attachments = assignmentElement.attachments
        guard let term = SakaiService.shared.siteTermMap[siteId] else {
            throw SakaiError.parseError("Could not find valid Term")
        }
        self.term = term
    }
}
