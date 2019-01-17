//
//  Assignment.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/10/18.
//

import Foundation

/// The model for an Assignment item
struct Assignment: TermSortable, SiteSortable {

    enum Status {
        case open, closed

        var descriptor: String {
            switch self {
            case .closed:
                return "Closed"
            case .open:
                return "Open"
            }
        }
    }

    let title: String
    let dueTimeString: String
    let dueDate: Date
    let instructions: String?
    let attributedInstructions: NSAttributedString?
    let term: Term
    let siteId: String
    let siteTitle: String?
    let status: Status
    let maxPoints: String?
    let currentGrade: String?
    let resubmissionAllowed: Bool?
    let attachments: [AttachmentElement]?
    let allowsInlineSubmission: Bool
    let siteURL: String
    let subjectCode: Int?
}

extension Assignment: Decodable {
    init(from decoder: Decoder) throws {
        let assignmentElement = try AssignmentElement(from: decoder)
        let title = assignmentElement.title
        let dueTimeString = assignmentElement.dueTimeString
        let dueDate = assignmentElement.dueTime.time
        let instructions = assignmentElement.instructions
        let attributedInstructions = instructions?.htmlAttributedString
        let siteId = assignmentElement.siteId
        let siteTitle = SakaiService.shared.siteTitleMap[siteId]
        let status = assignmentElement.status == Status.open.descriptor ? Status.open : Status.closed
        let resubmissionAllowed = assignmentElement.resubmissionAllowed
        guard let assignmentsUrl = SakaiService.shared.siteAssignmentToolMap[siteId] else {
            throw SakaiError.parseError("Could not find associated Assignment page for Site")
        }
        let siteURL = assignmentsUrl +
            "?assignmentReference=\(assignmentElement.reference)&sakai_action=doView_submission"
        let maxPoints = assignmentElement.maxPoints
        let currentGrade: String? = nil
        let attachments = assignmentElement.attachments
        let allowsInlineSubmission = assignmentElement.submissionType.contains("Inline")
        guard let term = SakaiService.shared.siteTermMap[siteId] else {
            throw SakaiError.parseError("Could not find valid Term")
        }
        let code = SakaiService.shared.siteSubjectCode[siteId]
        self.init(title: title,
                  dueTimeString: dueTimeString,
                  dueDate: dueDate,
                  instructions: instructions,
                  attributedInstructions: attributedInstructions,
                  term: term,
                  siteId: siteId,
                  siteTitle: siteTitle,
                  status: status,
                  maxPoints: maxPoints,
                  currentGrade: currentGrade,
                  resubmissionAllowed: resubmissionAllowed,
                  attachments: attachments,
                  allowsInlineSubmission: allowsInlineSubmission,
                  siteURL: siteURL,
                  subjectCode: code)
    }
}
