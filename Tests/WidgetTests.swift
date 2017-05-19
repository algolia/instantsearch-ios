//
//  WidgetTests.swift
//  WidgetTests
//
//  Copyright © 2016 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearch
import InstantSearchCore
import AlgoliaSearch

class WidgetTests: XCTestCase {
    
    var instantSearch: InstantSearch!
    private let ALGOLIA_APP_ID = "latency"
    private let ALGOLIA_INDEX_NAME = "bestbuy_promo"
    private let ALGOLIA_API_KEY = "1f6fd3a6fb973cb08419fe7d288fa4db"
    var expectation: XCTestExpectation!
    var defaultRect: CGRect = CGRect(x: 0, y: 0, width: 10, height: 10)
    
    
    override func setUp() {
        super.setUp()
        instantSearch = InstantSearch(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY, index: ALGOLIA_INDEX_NAME)
        instantSearch.params.attributesToRetrieve = ["name", "salePrice"]
        instantSearch.params.attributesToHighlight = ["name"]
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddHitsWidgets() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let hitsTableWidget = HitsTableWidget(frame: defaultRect)
        
        view.addSubview(hitsTableWidget)
        
        // Make sure that we didn't set the hitsPerPage param before adding the widget.
        XCTAssertNil(instantSearch.searcher.params.hitsPerPage)
        
        instantSearch.addAllWidgets(in: view, doSearch: false)
        
        // Make sure params.hitsPerPage was correctly set to the default by just adding the hits widget.
        XCTAssertEqual(instantSearch.searcher.params.hitsPerPage, Constants.Defaults.hitsPerPage)
    }
    
    func testAddRefinementMenu() {
        let expectation = self.expectation(description: "\(#function)\(#line)")
        
        // Setup refinement widget along with its controller
        let refinementTableWidget = RefinementTableWidget(frame: defaultRect)
        refinementTableWidget.attribute = "category"
        let refinementController = RefinementController(table: refinementTableWidget)
        refinementTableWidget.dataSource = refinementController
        refinementTableWidget.delegate = refinementController
        var didSearch = false
        let MoviesAndTvShowsCount = 1574
        
        XCTAssertNil(instantSearch.params.facets)
        XCTAssertTrue(instantSearch.params.facetRefinements.isEmpty)
        
        instantSearch.searcher.addResultHandler { results,_,_ in
            if !didSearch { // First search: adding the widget
                // select the first item in the category refinement list
                refinementTableWidget.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
                refinementController.tableView(refinementTableWidget, didSelectRowAt: IndexPath(row: 0, section: 0))
                didSearch = true
            } else { // Second search: selecting the refinement
                XCTAssertEqual(results?.nbHits, MoviesAndTvShowsCount)
                expectation.fulfill()
            }
        }
        
        instantSearch.add(widget: refinementTableWidget, doSearch: true)
        XCTAssertEqual(instantSearch.params.facets!, ["category"])
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAddHitsWidgetsWithCustomParameters() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let hitsTableWidget = HitsTableWidget(frame: defaultRect)
        hitsTableWidget.hitsPerPage = 5
        
        view.addSubview(hitsTableWidget)
        
        // Make sure that we didn't set the hitsPerPage param before adding the widget.
        XCTAssertNil(instantSearch.searcher.params.hitsPerPage)
        
        instantSearch.addAllWidgets(in: view, doSearch: false)
        
        // Make sure params.hitsPerPage was correctly set by just adding the hits widget.
        XCTAssertEqual(instantSearch.searcher.params.hitsPerPage, 5)
    }
}
