//
//  ConfigureInstantSearchTests.swift
//  ConfigureInstantSearchTests
//
//  Copyright © 2016 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearch
import InstantSearchCore
import InstantSearchClient

class ConfigureInstantSearchTests: XCTestCase {
    
    private let ALGOLIA_APP_ID = "latency"
    private let ALGOLIA_INDEX_NAME = "bestbuy_promo"
    private let ALGOLIA_API_KEY = "1f6fd3a6fb973cb08419fe7d288fa4db"
    var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitInstantSearchWithSingletonConfigure() {
        InstantSearch.shared.configure(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY, index: ALGOLIA_INDEX_NAME)
        InstantSearch.shared.params.attributesToRetrieve = ["name", "salePrice"]
        InstantSearch.shared.params.attributesToHighlight = ["name"]
        
        // Make sure a Searcher was actually created
        XCTAssertNotNil(InstantSearch.shared.searcher)
        
        // Make sure params of InstantSearch are linked to searcher.params
        XCTAssertEqual(InstantSearch.shared.params, InstantSearch.shared.searcher.params)
        
        InstantSearch.shared.searcher.addResultHandler(resultHandler(_:_:_:))
        
        // TODO(test): This needs to be mocked!
        InstantSearch.shared.searcher.search()
        
        // Expect that search goes well
        expectation = self.expectation(description: "Search in \(ALGOLIA_INDEX_NAME)")
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testInitInstantSearchWithSearcher() {
        let client = Client(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY)
        let index = client.index(withName: ALGOLIA_INDEX_NAME)
        let searcher = Searcher(index: index)
        let instantSearch = InstantSearch(searcher: searcher)
        instantSearch.params.attributesToRetrieve = ["name", "salePrice"]
        instantSearch.params.attributesToHighlight = ["name"]
        
        // Make sure that Searcher of the singleton is not set
        XCTAssertNil(InstantSearch.shared.searcher)
        
        // Make sure that searcher in InstantSearch instance is set
        XCTAssertNotNil(instantSearch.searcher)
        
        instantSearch.searcher.addResultHandler(resultHandler(_:_:_:))
        
        // TODO(test): This needs to be mocked!
        instantSearch.searcher.search()
        
        // Expect that search goes well
        expectation = self.expectation(description: "Search in \(ALGOLIA_INDEX_NAME)")
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func resultHandler(_ results: SearchResults?, _ error: Error?, _ userInfo: [String: Any]) {
        expectation.fulfill()
    }
}
