//
//  RawGradeItem.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/30/18.
//

import Foundation

struct RawGradeItem: Decodable {
    let grade: String?
    let points: Double
    let title: String

    enum CodingKeys: String, CodingKey {
        case grade, points
        case title = "itemName"
    }
}
