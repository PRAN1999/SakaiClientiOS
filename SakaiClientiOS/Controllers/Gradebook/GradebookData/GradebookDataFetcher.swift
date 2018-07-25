//
//  GradebookDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/12/18.
//

import Foundation
import ReusableSource

class GradebookDataFetcher : HideableDataFetcher {
    typealias T = [[GradeItem]]
    
    func loadData(for section: Int, completion: @escaping ([[GradeItem]]?) -> Void) {
        let sites = SakaiService.shared.termMap[section].1
        SakaiService.shared.getTermGrades(for: sites) { (res) in
            completion(res)
        }
    }
}
