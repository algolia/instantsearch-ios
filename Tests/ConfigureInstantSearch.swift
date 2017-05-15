//
//  ConfigureInstantSearch.swift
//  ConfigureInstantSearch
//
//  Copyright © 2016 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearch
import InstantSearchCore
import AlgoliaSearch

class ConfigureInstantSearch: XCTestCase {
    
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
        InstantSearch.reference.configure(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY, index: ALGOLIA_INDEX_NAME)
        InstantSearch.reference.params.attributesToRetrieve = ["name", "salePrice"]
        InstantSearch.reference.params.attributesToHighlight = ["name"]
        
        XCTAssertNotNil(InstantSearch.reference.searcher)
        XCTAssertEqual(InstantSearch.reference.params, InstantSearch.reference.searcher.params)
        InstantSearch.reference.searcher.addResultHandler(resultHandler(_:_:_:))
        
        // TODO: This needs to be mocked!
        InstantSearch.reference.searcher.search()
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
        
        XCTAssertNil(InstantSearch.reference.searcher)
        XCTAssertNotNil(instantSearch.searcher)
        instantSearch.searcher.addResultHandler(resultHandler(_:_:_:))
        
        // TODO: This needs to be mocked!
        instantSearch.searcher.search()
        expectation = self.expectation(description: "Search in \(ALGOLIA_INDEX_NAME)")
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func resultHandler(_ results: SearchResults?, _ error: Error?, _ userInfo: [String: Any]) {
        expectation.fulfill()
    }
}
