//
//  AnalyticsTests.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 19/02/2019.
//

import XCTest
@testable import InstantSearch
import InstantSearchCore
import InstantSearchClient

class AnalyticsTests: XCTestCase {
    
    func testTableWidgetnCAEventCapturing() {
        
        let exp = expectation(description: #function)
        
        let widget = HitsTableWidget(frame: .zero)
        
        widget.enableClickAnalytics = true
        widget.index = "testIndex"
        widget.hitClickEventName = "testEventName"
        
        let viewModel = HitsViewModel(view: widget)
        let caTestHelper = TestClickAnalyticsHelper()
        
        caTestHelper.handler = { eventName, indexName, objectID, position, queryID in
            XCTAssertEqual(eventName, "testEventName")
            XCTAssertEqual(indexName, "testIndex")
            XCTAssertEqual(objectID, "testObjectID")
            XCTAssertEqual(position, 1)
            XCTAssertEqual(queryID, "testQueryID")
            exp.fulfill()
        }
        
        viewModel.clickAnalyticsDelegate = caTestHelper
        let params = SearchParameters()
        let results = try! SearchResults(content: ["nbHits": 1 ,
                                                   "hits": [["objectID": "testObjectID"]],
                                                   "queryID": "testQueryID"],
                                         disjunctiveFacets: [])
        let searchResultsManager = TestSearchResultsManager(indexName: "testIndex",
                                                            variant: "testVariant",
                                                            params: params,
                                                            results: results)
        viewModel.configure(with: searchResultsManager)
        viewModel.captureClickAnalyticsForHit(at: IndexPath(row: 0, section: 0))
        
        waitForExpectations(timeout: 2, handler: .none)
        
    }
    
    func testCollectionWidgetCAEventCapturing() {
        
        let exp = expectation(description: #function)
        
        let widget = HitsCollectionWidget(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        widget.enableClickAnalytics = true
        widget.index = "testIndex"
        widget.hitClickEventName = "testEventName"
        
        let viewModel = HitsViewModel(view: widget)
        let caTestHelper = TestClickAnalyticsHelper()
        
        caTestHelper.handler = { eventName, indexName, objectID, position, queryID in
            XCTAssertEqual(eventName, "testEventName")
            XCTAssertEqual(indexName, "testIndex")
            XCTAssertEqual(objectID, "testObjectID")
            XCTAssertEqual(position, 1)
            XCTAssertEqual(queryID, "testQueryID")
            exp.fulfill()
        }
        
        viewModel.clickAnalyticsDelegate = caTestHelper
        let params = SearchParameters()
        let results = try! SearchResults(content: ["nbHits": 1 ,
                                                   "hits": [["objectID": "testObjectID"]],
                                                   "queryID": "testQueryID"],
                                         disjunctiveFacets: [])
        let searchResultsManager = TestSearchResultsManager(indexName: "testIndex",
                                                            variant: "testVariant",
                                                            params: params,
                                                            results: results)
        viewModel.configure(with: searchResultsManager)
        viewModel.captureClickAnalyticsForHit(at: IndexPath(row: 0, section: 0))
        
        waitForExpectations(timeout: 2, handler: .none)
        
    }
    
    func testTableWidgetMultiHitCAEventCapturing() {
        
        let exp = expectation(description: #function)
        exp.expectedFulfillmentCount = 2
        
        let widget = MultiHitsTableWidget(frame: .zero)
        
        widget.enableClickAnalytics = true
        widget.indicesArray = ["testIndex1", "testIndex2"]
        widget.setHitClick(eventName: "testEventName1", forSection: 0)
        widget.setHitClick(eventName: "testEventName2", forSection: 1)
        
        let viewModel = MultiHitsViewModel(view: widget)
        viewModel.searcherIds = [
            SearcherId(index: "testIndex1", variant: "testVariant1"),
            SearcherId(index: "testIndex2", variant: "testVariant2")
        ]
        
        let caTestHelper = TestClickAnalyticsHelper()
        
        caTestHelper.handler = { eventName, indexName, objectID, position, queryID in
            switch eventName {
            case "testEventName1":
                XCTAssertEqual(indexName, "testIndex1")
                XCTAssertEqual(objectID, "testObjectID1")
                XCTAssertEqual(position, 1)
                XCTAssertEqual(queryID, "testQueryID1")
                
            case "testEventName2":
                XCTAssertEqual(eventName, "testEventName2")
                XCTAssertEqual(indexName, "testIndex2")
                XCTAssertEqual(objectID, "testObjectID2")
                XCTAssertEqual(position, 1)
                
            default:
                XCTFail("Unexpected event name: \(eventName)")
            }
            
            exp.fulfill()
        }
        
        viewModel.clickAnalyticsDelegate = caTestHelper
        
        let params = SearchParameters()
        let results1 = try! SearchResults(content: ["nbHits": 1,
                                                    "hits": [["objectID": "testObjectID1"]],
                                                    "queryID": "testQueryID1"],
                                          disjunctiveFacets: [])
        
        let results2 = try! SearchResults(content: ["nbHits": 1,
                                                    "hits": [["objectID": "testObjectID2"]],
                                                    "queryID": "testQueryID2"],
                                          disjunctiveFacets: [])
        
        let searchResultsManager1 = TestSearchResultsManager(indexName: "testIndex1",
                                                             variant: "testVariant1",
                                                             params: params,
                                                             results: results1)
        
        let searchResultsManager2 = TestSearchResultsManager(indexName: "testIndex2",
                                                             variant: "testVariant2",
                                                             params: params,
                                                             results: results2)
        
        viewModel.configure(with: [searchResultsManager1, searchResultsManager2])
        
        viewModel.captureClickAnalyticsForHit(at: IndexPath(row: 0, section: 0))
        viewModel.captureClickAnalyticsForHit(at: IndexPath(row: 0, section: 1))
        
        waitForExpectations(timeout: 2, handler: .none)
        
        
    }
    
    func testCollectionWidgetMultiHitCAEventCapturing() {
        
        let exp = expectation(description: #function)
        exp.expectedFulfillmentCount = 2
        
        let widget = MultiHitsCollectionWidget(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        widget.enableClickAnalytics = true
        widget.indicesArray = ["testIndex1", "testIndex2"]
        widget.setHitClick(eventName: "testEventName1", forSection: 0)
        widget.setHitClick(eventName: "testEventName2", forSection: 1)
        
        let viewModel = MultiHitsViewModel(view: widget)
        viewModel.searcherIds = [
            SearcherId(index: "testIndex1", variant: "testVariant1"),
            SearcherId(index: "testIndex2", variant: "testVariant2")
        ]
        
        let caTestHelper = TestClickAnalyticsHelper()
        
        caTestHelper.handler = { eventName, indexName, objectID, position, queryID in
            switch eventName {
            case "testEventName1":
                XCTAssertEqual(indexName, "testIndex1")
                XCTAssertEqual(objectID, "testObjectID1")
                XCTAssertEqual(position, 1)
                XCTAssertEqual(queryID, "testQueryID1")
                
            case "testEventName2":
                XCTAssertEqual(eventName, "testEventName2")
                XCTAssertEqual(indexName, "testIndex2")
                XCTAssertEqual(objectID, "testObjectID2")
                XCTAssertEqual(position, 1)
                
            default:
                XCTFail("Unexpected event name: \(eventName)")
            }
            
            exp.fulfill()
        }
        
        viewModel.clickAnalyticsDelegate = caTestHelper
        
        let params = SearchParameters()
        let results1 = try! SearchResults(content: ["nbHits": 1,
                                                    "hits": [["objectID": "testObjectID1"]],
                                                    "queryID": "testQueryID1"],
                                          disjunctiveFacets: [])
        
        let results2 = try! SearchResults(content: ["nbHits": 1,
                                                    "hits": [["objectID": "testObjectID2"]],
                                                    "queryID": "testQueryID2"],
                                          disjunctiveFacets: [])
        
        let searchResultsManager1 = TestSearchResultsManager(indexName: "testIndex1",
                                                             variant: "testVariant1",
                                                             params: params,
                                                             results: results1)
        
        let searchResultsManager2 = TestSearchResultsManager(indexName: "testIndex2",
                                                             variant: "testVariant2",
                                                             params: params,
                                                             results: results2)
        
        viewModel.configure(with: [searchResultsManager1, searchResultsManager2])
        
        viewModel.captureClickAnalyticsForHit(at: IndexPath(row: 0, section: 0))
        viewModel.captureClickAnalyticsForHit(at: IndexPath(row: 0, section: 1))
        
        waitForExpectations(timeout: 2, handler: .none)
        
    }
    
    func testHitsControllerCACapturing() {
        
        let exp = expectation(description: #function)
        
        let widget = HitsTableWidget(frame: .zero)
        
        widget.enableClickAnalytics = true
        widget.index = "testIndex"
        widget.hitClickEventName = "testEventName"
        
        let viewModel = HitsViewModel(view: widget)
        widget.viewModel = viewModel
        let caTestHelper = TestClickAnalyticsHelper()
        
        caTestHelper.handler = { eventName, indexName, objectID, position, queryID in
            XCTAssertEqual(eventName, "testEventName")
            XCTAssertEqual(indexName, "testIndex")
            XCTAssertEqual(objectID, "testObjectID")
            XCTAssertEqual(position, 1)
            XCTAssertEqual(queryID, "testQueryID")
            exp.fulfill()
        }
        
        viewModel.clickAnalyticsDelegate = caTestHelper
        let params = SearchParameters()
        let results = try! SearchResults(content: ["nbHits": 1 ,
                                                   "hits": [["objectID": "testObjectID"]],
                                                   "queryID": "testQueryID"],
                                         disjunctiveFacets: [])
        let searchResultsManager = TestSearchResultsManager(indexName: "testIndex",
                                                            variant: "testVariant",
                                                            params: params,
                                                            results: results)
        viewModel.configure(with: searchResultsManager)
        
        let hitsController = HitsController(table: widget)
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        hitsController.tableView(widget, didSelectRowAt: indexPath)
        
        waitForExpectations(timeout: 2, handler: .none)
        
    }
    
}

class TestSearchResultsManager: SearchResultsManageable {
    
    let indexName: String
    let variant: String
    let params: InstantSearchCore.SearchParameters
    let results: InstantSearchCore.SearchResults?
    
    init(indexName: String,
         variant: String,
         params: InstantSearchCore.SearchParameters,
         results: InstantSearchCore.SearchResults?) {
        self.indexName = indexName
        self.variant = variant
        self.params = params
        self.results = results
    }
    
    func loadMore() {}
    
}

class TestClickAnalyticsHelper: ClickAnalyticsDelegate {
    
    var handler: ((String, String, String, Int, String) -> Void)?
    
    func clickedAfterSearch(eventName: String,
                            indexName: String,
                            objectID: String,
                            position: Int,
                            queryID: String) {
        handler?(eventName, indexName, objectID, position, queryID)
    }
    
}
