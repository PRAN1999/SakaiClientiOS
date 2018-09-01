//
//  GradeItem.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/13/18.
//

import Foundation

/// Represents a Gradebook entry for a user's gradebook
///
/// Can be sorted by Term and by Site
struct GradeItem: TermSortable, SiteSortable {
    let grade: String?
    let points: Double
    let title: String
    let term: Term
    let siteId: String
}
