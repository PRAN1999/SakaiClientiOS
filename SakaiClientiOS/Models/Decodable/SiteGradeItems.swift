//
//  SiteGradeItems.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/30/18.
//

import Foundation

struct SiteGradeItems: Decodable {
    let gradeItems: [GradeItem]
    let siteId: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.siteId = try container.decode(String.self, forKey: .siteId)

        guard let term = SakaiService.shared.siteTermMap[siteId] else {
            throw SakaiError.parseError("No valid Term found")
        }

        guard let siteTitle = SakaiService.shared.siteTitleMap[siteId] else {
            throw SakaiError.parseError("No Site Title Found")
        }
        
        let rawGradeItems = try container.decode([RawGradeItem].self, forKey: .gradeItems)
        var gradeItems = [GradeItem]()
        for rawGradeItem in rawGradeItems {
            let gradeItem = GradeItem(grade: rawGradeItem.grade,
                                      points: rawGradeItem.points,
                                      title: rawGradeItem.title,
                                      term: term,
                                      siteId: siteId,
                                      siteTitle: siteTitle)
            gradeItems.append(gradeItem)
        }
        self.gradeItems = gradeItems
    }

    enum CodingKeys: String, CodingKey {
        case gradeItems = "assignments"
        case siteId
    }
}
