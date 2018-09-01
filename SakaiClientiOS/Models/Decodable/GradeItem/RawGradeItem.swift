//
//  RawGradeItem.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/31/18.
//

import Foundation

struct GradeItemCollection: Decodable {
    let gradeItems: [GradeItem]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let siteGradeItems = try container.decode([SiteGradeItems].self, forKey: .gradebookCollection)
        self.gradeItems = siteGradeItems.flatMap { $0.gradeItems }
    }

    enum CodingKeys: String, CodingKey {
        case gradebookCollection = "gradebook_collection"
    }
}

struct SiteGradeItems: Decodable {
    let gradeItems: [GradeItem]
    let siteId: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.siteId = try container.decode(String.self, forKey: .siteId)
        guard let term = SakaiService.shared.siteTermMap[siteId] else {
            throw SakaiError.parseError("No valid Term found")
        }
        let rawGradeItems = try container.decode([RawGradeItem].self, forKey: .gradeItems)
        var gradeItems = [GradeItem]()
        for rawGradeItem in rawGradeItems {
            let gradeItem = GradeItem(grade: rawGradeItem.grade, points: rawGradeItem.points, title: rawGradeItem.title, term: term, siteId: siteId)
            gradeItems.append(gradeItem)
        }
        self.gradeItems = gradeItems
    }

    enum CodingKeys: String, CodingKey {
        case gradeItems = "assignments"
        case siteId
    }
}

struct RawGradeItem: Decodable {
    let grade: String?
    let points: Double
    let title: String

    enum CodingKeys: String, CodingKey {
        case grade, points
        case title = "itemName"
    }
}
