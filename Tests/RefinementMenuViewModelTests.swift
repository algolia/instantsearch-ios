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
        searchParameters.addFacetRefinement(name: facetName, value: "Flat-Panel TVs")
        searchParameters.addFacetRefinement(name: facetName, value: "Facet Refinement New Value")
        
        let actualRefinementList = refinementVM.getRefinementList(params: searchParameters, facetCounts: facetCounts, andFacetName: facetName, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        
        let expectedRefinementList = [
            FacetValue(value: "Movies & TV Shows", count: 1574),
            FacetValue(value: "Cell Phone Cases & Clips", count: 572),
            FacetValue(value: "Flat-Panel TVs", count: 190),
            FacetValue(value: "Headphones", count: 188),
            FacetValue(value: "iPad Cases, Covers & Sleeves", count: 165),
            FacetValue(value: "Facet Refinement New Value", count: 0)
        ]
        
        XCTAssertEqual(actualRefinementList.count, expectedRefinementList.count)
        XCTAssertEqual(actualRefinementList, expectedRefinementList)
    }
    
    func testGetRefinementListCountDescRefined() {
        let refinementVM = RefinementMenuViewModel()
        
        let facetName = "category"
        let transformRefinementList = TransformRefinementList.countDesc
        let areRefinedValuesFirst = true
        
        let searchParameters = SearchParameters()
        searchParameters.addFacetRefinement(name: facetName, value: "Flat-Panel TVs")
        searchParameters.addFacetRefinement(name: facetName, value: "Cell Phone Cases & Clips")
        searchParameters.addFacetRefinement(name: facetName, value: "Facet Refinement New Value")
        
        let expectedRefinementList = [
            FacetValue(value: "Cell Phone Cases & Clips", count: 572), // Show refined ones first
            FacetValue(value: "Flat-Panel TVs", count: 190), // Show refined ones first
            FacetValue(value: "Facet Refinement New Value", count: 0), // Show refined ones first
            FacetValue(value: "Movies & TV Shows", count: 1574),
            FacetValue(value: "Headphones", count: 188),
            FacetValue(value: "iPad Cases, Covers & Sleeves", count: 165)
        ]
        
        let actualRefinementList = refinementVM.getRefinementList(params: searchParameters, facetCounts: facetCounts, andFacetName: facetName, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        
        XCTAssertEqual(actualRefinementList.count, expectedRefinementList.count)
        XCTAssertEqual(actualRefinementList, expectedRefinementList)

    }
    
    func testGetRefinementListCountAscNotRefined() {
        let refinementVM = RefinementMenuViewModel()
        
        let facetName = "category"
        let transformRefinementList = TransformRefinementList.countAsc
        let areRefinedValuesFirst = false
        
        let searchParameters = SearchParameters()
        searchParameters.addFacetRefinement(name: facetName, value: "Flat-Panel TVs")
        searchParameters.addFacetRefinement(name: facetName, value: "Facet Refinement New Value")
        
        let actualRefinementList = refinementVM.getRefinementList(params: searchParameters, facetCounts: facetCounts, andFacetName: facetName, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        
        let expectedRefinementList = [
            FacetValue(value: "Facet Refinement New Value", count: 0),
            FacetValue(value: "iPad Cases, Covers & Sleeves", count: 165),
            FacetValue(value: "Headphones", count: 188),
            FacetValue(value: "Flat-Panel TVs", count: 190),
            FacetValue(value: "Cell Phone Cases & Clips", count: 572),
            FacetValue(value: "Movies & TV Shows", count: 1574),
        ]
        
        XCTAssertEqual(actualRefinementList.count, expectedRefinementList.count)
        XCTAssertEqual(actualRefinementList, expectedRefinementList)
    }
    
    func testGetRefinementListCountAscRefined() {
        let refinementVM = RefinementMenuViewModel()
        
        let facetName = "category"
        let transformRefinementList = TransformRefinementList.countAsc
        let areRefinedValuesFirst = true
        
        let searchParameters = SearchParameters()
        searchParameters.addFacetRefinement(name: facetName, value: "Flat-Panel TVs")
        searchParameters.addFacetRefinement(name: facetName, value: "Cell Phone Cases & Clips")
        searchParameters.addFacetRefinement(name: facetName, value: "Facet Refinement New Value")
        
        let actualRefinementList = refinementVM.getRefinementList(params: searchParameters, facetCounts: facetCounts, andFacetName: facetName, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        
        let expectedRefinementList = [
            FacetValue(value: "Facet Refinement New Value", count: 0), // Show refined ones first
            FacetValue(value: "Flat-Panel TVs", count: 190), // Show refined ones first
            FacetValue(value: "Cell Phone Cases & Clips", count: 572), // Show refined ones first
            FacetValue(value: "iPad Cases, Covers & Sleeves", count: 165),
            FacetValue(value: "Headphones", count: 188),
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
        searchParameters.addFacetRefinement(name: facetName, value: "Flat-Panel TVs")
        searchParameters.addFacetRefinement(name: facetName, value: "Facet Refinement New Value")
        
        let actualRefinementList = refinementVM.getRefinementList(params: searchParameters, facetCounts: facetCounts, andFacetName: facetName, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        
        let expectedRefinementList = [
            FacetValue(value: "Cell Phone Cases & Clips", count: 572),
            FacetValue(value: "Facet Refinement New Value", count: 0),
            FacetValue(value: "Flat-Panel TVs", count: 190),
            FacetValue(value: "Headphones", count: 188),
            FacetValue(value: "iPad Cases, Covers & Sleeves", count: 165),
            FacetValue(value: "Movies & TV Shows", count: 1574),
        ]
        
        XCTAssertEqual(actualRefinementList.count, expectedRefinementList.count)
        XCTAssertEqual(actualRefinementList, expectedRefinementList)
    }
    
    func testGetRefinementListNameAscRefined() {
        let refinementVM = RefinementMenuViewModel()
        
        let facetName = "category"
        let transformRefinementList = TransformRefinementList.nameAsc
        let areRefinedValuesFirst = true
        
        let searchParameters = SearchParameters()
        searchParameters.addFacetRefinement(name: facetName, value: "Flat-Panel TVs")
        searchParameters.addFacetRefinement(name: facetName, value: "Cell Phone Cases & Clips")
        searchParameters.addFacetRefinement(name: facetName, value: "Facet Refinement New Value")
        
        let actualRefinementList = refinementVM.getRefinementList(params: searchParameters, facetCounts: facetCounts, andFacetName: facetName, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        
        let expectedRefinementList = [
            FacetValue(value: "Cell Phone Cases & Clips", count: 572), // Show refined ones first
            FacetValue(value: "Facet Refinement New Value", count: 0), // Show refined ones first
            FacetValue(value: "Flat-Panel TVs", count: 190), // Show refined ones first
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
        searchParameters.addFacetRefinement(name: facetName, value: "Flat-Panel TVs")
        searchParameters.addFacetRefinement(name: facetName, value: "Facet Refinement New Value")
        
        let actualRefinementList = refinementVM.getRefinementList(params: searchParameters, facetCounts: facetCounts, andFacetName: facetName, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        
        let expectedRefinementList = [
            FacetValue(value: "Movies & TV Shows", count: 1574),
            FacetValue(value: "iPad Cases, Covers & Sleeves", count: 165),
            FacetValue(value: "Headphones", count: 188),
            FacetValue(value: "Flat-Panel TVs", count: 190),
            FacetValue(value: "Facet Refinement New Value", count: 0),
            FacetValue(value: "Cell Phone Cases & Clips", count: 572),
        ]
        
        XCTAssertEqual(actualRefinementList.count, expectedRefinementList.count)
        XCTAssertEqual(actualRefinementList, expectedRefinementList)
    }
    
    func testGetRefinementListNameDscRefined() {
        let refinementVM = RefinementMenuViewModel()
        
        let facetName = "category"
        let transformRefinementList = TransformRefinementList.nameDsc
        let areRefinedValuesFirst = true
        
        let searchParameters = SearchParameters()
        searchParameters.addFacetRefinement(name: facetName, value: "Flat-Panel TVs")
        searchParameters.addFacetRefinement(name: facetName, value: "Cell Phone Cases & Clips")
        searchParameters.addFacetRefinement(name: facetName, value: "Facet Refinement New Value")
        
        let actualRefinementList = refinementVM.getRefinementList(params: searchParameters, facetCounts: facetCounts, andFacetName: facetName, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        
        let expectedRefinementList = [
            FacetValue(value: "Flat-Panel TVs", count: 190), // Show refined ones first
            FacetValue(value: "Facet Refinement New Value", count: 0), // Show refined ones first
            FacetValue(value: "Cell Phone Cases & Clips", count: 572), // Show refined ones first
            FacetValue(value: "Movies & TV Shows", count: 1574),
            FacetValue(value: "iPad Cases, Covers & Sleeves", count: 165),
            FacetValue(value: "Headphones", count: 188),
        ]
        
        XCTAssertEqual(actualRefinementList.count, expectedRefinementList.count)
        XCTAssertEqual(actualRefinementList, expectedRefinementList)
    }
    
    func testGetRefinementListEmptyFacetCounts() {
        let refinementVM = RefinementMenuViewModel()
        
        let facetName = "category"
        let transformRefinementList = TransformRefinementList.nameDsc
        let areRefinedValuesFirst = true
        
        let searchParameters = SearchParameters()
        
        let actualRefinementList = refinementVM.getRefinementList(params: searchParameters, facetCounts: [:], andFacetName: facetName, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        
        XCTAssertEqual(actualRefinementList, [])
    }
    
    func testGetRefinementListEmptyFacetCountsAndRefinements() {
        let refinementVM = RefinementMenuViewModel()
        
        let facetName = "category"
        let transformRefinementList = TransformRefinementList.nameDsc
        let areRefinedValuesFirst = true
        
        let searchParameters = SearchParameters()
        searchParameters.addFacetRefinement(name: facetName, value: "FacetValue")
        searchParameters.addFacetRefinement(name: "Another Facet Name", value: "FacetValue")
        searchParameters.addFacetRefinement(name: "Some other Facet Name", value: "Random Value")
        
        let actualRefinementList = refinementVM.getRefinementList(params: searchParameters, facetCounts: [:], andFacetName: facetName, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        
        let expectedRefinementList = [
            FacetValue(value: "FacetValue", count: 0)
        ]
        
        XCTAssertEqual(actualRefinementList, expectedRefinementList)
    }
}
