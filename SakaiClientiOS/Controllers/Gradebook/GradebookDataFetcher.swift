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

    private let termService: TermService
    private let networkService: NetworkService

    init(termService: TermService, networkService: NetworkService) {
        self.termService = termService
        self.networkService = networkService
    }
    
    func loadData(for section: Int, completion: @escaping ([[GradeItem]]?, Error?) -> Void) {
        guard section < termService.termMap.count else {
            return
        }
        let sites = termService.termMap[section].1
        let group = DispatchGroup()
        var termGradeArray: [[GradeItem]] = []
        var errors: [SakaiError] = []
        for site in sites {
            group.enter()
            let request = SakaiRequest<SiteGradeItems>(endpoint: .siteGradebook(site), method: .get)
            networkService.makeEndpointRequest(request: request) { data, err in
                if let err = err {
                    switch err {
                    case .networkError( _, let code):
                        if code == 400 { break }
                    default:
                        errors.append(err)
                    }
                }
                if let response = data {
                    termGradeArray.append(response.gradeItems)
                }
                group.leave()
            }
        }
        group.notify(queue: .global(), work: .init(block: {
            var error: SakaiError? = SakaiError.dispatchGroupError(errors)
            if errors.count == 0 {
                error = nil
            }
            completion(termGradeArray, error)
        }))
    }
}
