//
//  SiteDataFetcherTests.swift
//  SakaiClientiOSTests
//
//  Created by Pranay Neelagiri on 1/20/19.
//

import XCTest
@testable import SakaiClientiOS

class SiteDataFetcherTests: XCTestCase {

    var mockCacheUpdateService: MockCacheUpdateService!
    var mockNetworkService: MockNetworkService!

    var underTest: SiteDataFetcher!

    override func setUp() {
        // Setup
        mockCacheUpdateService = MockCacheUpdateService()
        mockNetworkService = MockNetworkService()
        underTest = SiteDataFetcher(cacheUpdateService: mockCacheUpdateService,
                                    networkService: mockNetworkService)
    }

    override func tearDown() {
        // Teardown
        underTest = nil
        mockNetworkService = nil
        mockCacheUpdateService = nil
    }

    func test_loadData_withSuccessfulNetworkRequest_shouldSplitSitesAndUpdateCache() {
        guard let data = Bundle(for: type(of: self)).data(forResource: "sites", ofType: "json") else {
            return
        }
        let decoder = JSONDecoder()
        guard let siteCollection = try? decoder.decode(SiteCollection.self, from: data) else {
            XCTFail("Failed to convert data into SiteCollection")
            return
        }

        mockNetworkService.response = siteCollection

        underTest.loadData { [weak self] _data, err in
            XCTAssertNil(err, "Err should be nil")

            guard let data = _data else {
                XCTFail("Response should not be nil")
                return
            }

            let termMap = self?.mockCacheUpdateService.termMap
            var termMapIndex = 0
            for list in data {
                XCTAssertTrue(list.count > 0, "Every Term has at least one represented site")
                let term = list[0].term
                if term.exists() {
                    XCTAssertEqual(term, termMap?[termMapIndex].0)
                    termMapIndex += 1
                }
            }
        }
    }
}
