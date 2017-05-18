//
//  RefinementMenuViewModelTests.swift
//  RefinementMenuViewModelTests
//
//  Copyright © 2016 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearch
@testable import InstantSearchCore

class RefinementMenuViewModelTests: XCTestCase {
    
    let facetCounts: [String: Int] = [
        "Headphones" : 188,
        "Flat-Panel TVs" : 190,
        "Movies & TV Shows" : 1574,
        "Cell Phone Cases & Clips" : 572,
        "iPad Cases, Covers & Sleeves" : 165
    ]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetRefinementListCountDescNotRefined() {
        let refinementVM = RefinementMenuViewModel()
        
        let facetName = "category"
        let transformRefinementList = TransformRefinementList.countDesc
        let areRefinedValuesFirst = false
        let searchParameters = SearchParameters()
        
        let actualRefinementList = refinementVM.getRefinementList(params: searchParameters, facetCounts: facetCounts, andFacetName: facetName, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        
        let expectedRefinementList = [
            FacetValue(value: "Movies & TV Shows", count: 1574),
            FacetValue(value: "Cell Phone Cases & Clips", count: 572),
            FacetValue(value: "Flat-Panel TVs", count: 190),
            FacetValue(value: "Headphones", count: 188),
            FacetValue(value: "iPad Cases, Covers & Sleeves", count: 165)
        ]
        
        XCTAssertEqual(actualRefinementList.count, expectedRefinementList.count)
        XCTAssertEqual(actualRefinementList, expectedRefinementList)
    }
    
    func testGetRefinementListCountAscNotRefined() {
        let refinementVM = RefinementMenuViewModel()
        
        let facetName = "category"
        let transformRefinementList = TransformRefinementList.countAsc
        let areRefinedValuesFirst = false
        let searchParameters = SearchParameters()
        
        let actualRefinementList = refinementVM.getRefinementList(params: searchParameters, facetCounts: facetCounts, andFacetName: facetName, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        
        let expectedRefinementList = [
            FacetValue(value: "iPad Cases, Covers & Sleeves", count: 165),
            FacetValue(value: "Headphones", count: 188),
            FacetValue(value: "Flat-Panel TVs", count: 190),
            FacetValue(value: "Cell Phone Cases & Clips", count: 572),
            FacetValue(value: "Movies & TV Shows", count: 1574),
        ]
        
        XCTAssertEqual(actualRefinementList.count, expectedRefinementList.count)
        XCTAssertEqual(actualRefinementList, expectedRefinementList)
    }
    
    func testGetRefinementListNameAscNotRefined() {
        let refinementVM = RefinementMenuViewModel()
        
        let facetName = "category"
        let transformRefinementList = TransformRefinementList.nameAsc
        let areRefinedValuesFirst = false
        let searchParameters = SearchParameters()
        
        let actualRefinementList = refinementVM.getRefinementList(params: searchParameters, facetCounts: facetCounts, andFacetName: facetName, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        
        let expectedRefinementList = [
            FacetValue(value: "Cell Phone Cases & Clips", count: 572),
            FacetValue(value: "Flat-Panel TVs", count: 190),
            FacetValue(value: "Headphones", count: 188),
            FacetValue(value: "iPad Cases, Covers & Sleeves", count: 165),
            FacetValue(value: "Movies & TV Shows", count: 1574),
            ]
        
        XCTAssertEqual(actualRefinementList.count, expectedRefinementList.count)
        XCTAssertEqual(actualRefinementList, expectedRefinementList)
    }
    
    func testGetRefinementListNameDscNotRefined() {
        let refinementVM = RefinementMenuViewModel()
        
        let facetName = "category"
        let transformRefinementList = TransformRefinementList.nameDsc
        let areRefinedValuesFirst = false
        let searchParameters = SearchParameters()
        
        let actualRefinementList = refinementVM.getRefinementList(params: searchParameters, facetCounts: facetCounts, andFacetName: facetName, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        
        let expectedRefinementList = [
            FacetValue(value: "Movies & TV Shows", count: 1574),
            FacetValue(value: "iPad Cases, Covers & Sleeves", count: 165),
            FacetValue(value: "Headphones", count: 188),
            FacetValue(value: "Flat-Panel TVs", count: 190),
            FacetValue(value: "Cell Phone Cases & Clips", count: 572),
            ]
        
        XCTAssertEqual(actualRefinementList.count, expectedRefinementList.count)
        XCTAssertEqual(actualRefinementList, expectedRefinementList)
    }
    
}
