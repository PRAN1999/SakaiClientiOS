//
//  SakaiService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/2/18.
//

import Foundation

class SakaiService {

    static let shared = SakaiService()

    // MARK: Source of Truth

    var siteTermMap: [String: Term] = [:]
    var siteTitleMap: [String: String] = [:]
    var siteAssignmentToolMap: [String: String] = [:]
    var termMap: [(Term, [String])] = []

    private init() {}

    /// Reset source of truth mappings for Terms and siteId's
    func reset() {
        siteTermMap = [:]
        siteTitleMap = [:]
        siteAssignmentToolMap = [:]
        termMap = []
    }

    // MARK: Authentication Validator

    func validateLoggedInStatus(onSuccess: @escaping () -> Void, onFailure: @escaping (SakaiError?) -> Void) {
        let url = SakaiEndpoint.session.getEndpoint()
        RequestManager.shared.makeRequestWithoutCache(url: url, method: .get) { (data, err) in
            let decoder = JSONDecoder()
            guard let data = data else {
                onFailure(err)
                return
            }
            do {
                let session = try decoder.decode(UserSession.self, from: data)
                RequestManager.shared.userId = session.userEid
                onSuccess()
            } catch let decodingError {
                onFailure(SakaiError.parseError(decodingError.localizedDescription))
            }
        }
    }
}
