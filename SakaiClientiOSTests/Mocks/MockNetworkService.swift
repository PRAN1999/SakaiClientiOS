//
//  BaseDataFetcherTests.swift
//  SakaiClientiOSTests
//
//  Created by Pranay Neelagiri on 1/20/19.
//
import Foundation
import XCTest
@testable import SakaiClientiOS

class MockNetworkService: NetworkService {

    var response: Decodable?
    var error: SakaiError?

    func makeEndpointRequest<T>(request: SakaiRequest<T>,
                                completion: @escaping (T?, SakaiError?) -> Void) where T : Decodable {
        if let response = response {
            guard let response = response as? T else {
                XCTFail("Response for Mock object is of the wrong type")
                return
            }
            completion(response, error)
            return
        }
        completion(nil, error)
    }

    func makeEndpointRequestWithoutCache<T>(request: SakaiRequest<T>, completion: @escaping (T?, SakaiError?) -> Void) where T : Decodable {
        makeEndpointRequest(request: request, completion: completion)
    }
}
