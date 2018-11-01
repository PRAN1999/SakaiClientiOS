//
//  GradebookDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/12/18.
//

import Foundation
import ReusableSource

/// The data fetcher for the Gradebook tab. Fetches gradebook data by Term as requested
class GradebookDataFetcher : HideableDataFetcher {
    typealias T = [[GradeItem]]
    
    func loadData(for section: Int, completion: @escaping ([[GradeItem]]?, Error?) -> Void) {
        let sites = SakaiService.shared.termMap[section].1
        SakaiService.shared.getTermGrades(for: sites) { res, err in
            completion(res, err)
        }
    }
}
