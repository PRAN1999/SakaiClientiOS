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
        gradeItems = siteGradeItems.flatMap { $0.gradeItems }
    }

    enum CodingKeys: String, CodingKey {
        case gradebookCollection = "gradebook_collection"
    }
}
