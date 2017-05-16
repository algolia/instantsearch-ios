//
//  InstantSearchTests.swift
//  InstantSearchTests
//
//  Copyright © 2016 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearch
import InstantSearchCore
import AlgoliaSearch

class InstantSearchTests: XCTestCase {
    
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
        let refinementTableWidget = RefinementTableWidget(frame: defaultRect)
        refinementTableWidget.attribute = "attributeName"
        let r = Hits
        var didSearch = false
        
        XCTAssertNil(instantSearch.params.facets)
        XCTAssertTrue(instantSearch.params.facetRefinements.isEmpty)
        
        instantSearch.searcher.addResultHandler { results,_,_ in
            if !didSearch {
                refinementTableWidget.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
                didSearch = true
            } else {
                XCTAssertEqual(results?.nbHits, 1574)
            }
        }
        
        instantSearch.add(widget: refinementTableWidget, doSearch: true)
        XCTAssertEqual(instantSearch.params.facets!, ["attributeName"])
        
        
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
    
//    func testExample() {
//        let refinementVM = RefinementMenuViewModel()
//        refinementVM.searcher = MockSearcher(index: )
//        
//        let facetCounts = [
//            "Headphones" : 188,
//            "Flat-Panel TVs" : 190,
//            "Movies & TV Shows" : 1574,
//            "Cell Phone Cases & Clips" : 572,
//            "iPad Cases, Covers & Sleeves" : 165,
//            "Tablet Cases, Covers & Sleeves" : 146,
//        ]
//        
//        let facetName = "category"
//        let transformRefinementList = TransformRefinementList.countDesc
//        let areRefinedValuesFirst = true
//        
//        refinementVM.getRefinementList(facetCounts: facetCounts, andFacetName: facetName, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
//    }
//
}
