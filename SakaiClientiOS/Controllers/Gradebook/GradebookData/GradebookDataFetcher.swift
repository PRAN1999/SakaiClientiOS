//
//  GradebookDataFetcher.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/12/18.
//

import Foundation
import ReusableDataSource

class GradebookDataFetcher : DataFetcher {
    
    typealias T = [[[GradeItem]]]
    
    func loadData(completion: @escaping ([[[GradeItem]]]?) -> Void) {
        DataHandler.shared.getAllGrades { (res) in
            completion(res)
        }
    }
}
