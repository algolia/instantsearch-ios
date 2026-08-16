//
//  CompositionSearcherTests.swift
//
//

import AlgoliaComposition
import Foundation
@testable import InstantSearchCore
import XCTest

class CompositionSearcherTests: XCTestCase {
  func testOnQueryChanged() throws {
    let searcher = try CompositionSearcher(appID: "testAppID", apiKey: "testApiKey", compositionID: "composition1")
    let exp = expectation(description: "Query change expectation")
    searcher.onQueryChanged.subscribe(with: self) { _, newQuery in
      XCTAssertEqual(newQuery, "new query")
      exp.fulfill()
    }
    searcher.query = "new query"
    waitForExpectations(timeout: 2, handler: .none)
  }

  func testOnSearch() throws {
    let searcher = try CompositionSearcher(appID: "testAppID", apiKey: "testApiKey", compositionID: "composition1")
    let exp = expectation(description: "Search expectation")
    searcher.onSearch.subscribe(with: self) { _, _ in
      exp.fulfill()
    }
    searcher.search()
    waitForExpectations(timeout: 2, handler: .none)
  }

  func testConditionalSearch() throws {
    let searcher = try CompositionSearcher(appID: "testAppID", apiKey: "testApiKey", compositionID: "composition1")
    let exp = expectation(description: "Search expectation")
    exp.isInverted = true
    searcher.onSearch.subscribe(with: self) { _, _ in
      exp.fulfill()
    }
    searcher.shouldTriggerSearchForQuery = { request in
      return request.params.query ?? "" != ""
    }
    searcher.query = nil
    searcher.search()
    waitForExpectations(timeout: 2, handler: .none)
  }

  func testPageResetOnQueryChange() throws {
    let searcher = try CompositionSearcher(appID: "testAppID", apiKey: "testApiKey", compositionID: "composition1")
    searcher.request.params.page = 3
    searcher.request.params.query = "new query"
    XCTAssertEqual(searcher.request.params.page, 0)
  }

  func testSetFilters() throws {
    let searcher = try CompositionSearcher(appID: "testAppID", apiKey: "testApiKey", compositionID: "composition1")
    searcher.request.params.page = 3
    searcher.setFilters("\"color\":\"red\"")
    XCTAssertEqual(searcher.request.params.filters, "\"color\":\"red\"")
    XCTAssertEqual(searcher.request.params.page, 0)
  }

  func testLoadPage() throws {
    let searcher = try CompositionSearcher(appID: "testAppID", apiKey: "testApiKey", compositionID: "composition1")
    searcher.loadPage(atIndex: 5)
    XCTAssertEqual(searcher.request.params.page, 5)
  }

  func testFilterStateConnection() throws {
    let searcher = try CompositionSearcher(appID: "testAppID", apiKey: "testApiKey", compositionID: "composition1")
    let filterState = FilterState()
    searcher.connectFilterState(filterState)
    XCTAssertTrue(searcher.disjunctiveFacetingDelegate === filterState)

    let exp = expectation(description: "Search triggered on filter state change")
    searcher.onSearch.subscribe(with: self) { _, _ in
      exp.fulfill()
    }
    filterState[or: "color"].add(Filter.Facet(attribute: "color", stringValue: "red"))
    filterState.notifyChange()
    waitForExpectations(timeout: 2, handler: .none)

    XCTAssertEqual(searcher.request.params.filters, """
    ( "color":"red" )
    """)
  }

  func testDisjunctiveFacetsAnnotation() throws {
    let searcher = try CompositionSearcher(appID: "testAppID", apiKey: "testApiKey", compositionID: "composition1")
    searcher.disjunctiveFacetsAttributes = ["color"]
    var params = CompositionParams()
    params.facets = ["color", "brand"]
    let annotated = searcher.service.annotatingDisjunctiveFacets(params)
    XCTAssertEqual(Set(annotated.facets ?? []), ["disjunctive(color)", "brand"])
  }

  func testResponseMapping() {
    let hits: [SearchHit] = [Hit(object: makeJSONHit("h1")), Hit(object: makeJSONHit("h2"))]
    let item = SearchResultsItem<SearchHit>(facets: ["color": ["red": 1, "blue": 2]],
                                            facetsStats: ["price": CompositionFacetStats(min: 1, max: 10, avg: 5, sum: 20)],
                                            index: "myIndex",
                                            processingTimeMS: 7,
                                            queryID: "queryID",
                                            hits: hits,
                                            hitsPerPage: 20,
                                            nbHits: 2,
                                            nbPages: 1,
                                            page: 0,
                                            params: "query=phone",
                                            query: "phone",
                                            compositions: [:])
    let response = item.searchResponse
    XCTAssertEqual(response.hits.count, 2)
    XCTAssertEqual(response.nbHits, 2)
    XCTAssertEqual(response.nbPages, 1)
    XCTAssertEqual(response.page, 0)
    XCTAssertEqual(response.hitsPerPage, 20)
    XCTAssertEqual(response.query, "phone")
    XCTAssertEqual(response.params, "query=phone")
    XCTAssertEqual(response.queryID, "queryID")
    XCTAssertEqual(response.index, "myIndex")
    XCTAssertEqual(response.processingTimeMS, 7)
    XCTAssertEqual(response.facets?["color"], ["red": 1, "blue": 2])
    XCTAssertEqual(response.facetsStats?["price"]?.min, 1)
    XCTAssertEqual(response.facetsStats?["price"]?.max, 10)
    XCTAssertEqual(response.facetsStats?["price"]?.avg, 5)
    XCTAssertEqual(response.facetsStats?["price"]?.sum, 20)
  }

  func testFacetValuesResponseMapping() {
    let results = AlgoliaComposition.SearchForFacetValuesResults(
      indexName: "myIndex",
      facetHits: [CompositionFacetHits(value: "red", highlighted: "<em>red</em>", count: 3)],
      exhaustiveFacetsCount: true,
      processingTimeMS: 2
    )
    let response = results.searchForFacetValuesResponse
    XCTAssertEqual(response.facetHits.count, 1)
    XCTAssertEqual(response.facetHits.first?.value, "red")
    XCTAssertEqual(response.facetHits.first?.highlighted, "<em>red</em>")
    XCTAssertEqual(response.facetHits.first?.count, 3)
    XCTAssertEqual(response.exhaustiveFacetsCount, true)
    XCTAssertEqual(response.processingTimeMS, 2)
  }

  func testHitsInteractorConnection() throws {
    let searcher = try CompositionSearcher(appID: "testAppID", apiKey: "testApiKey", compositionID: "composition1")
    let interactor = HitsInteractor<SearchHit>(infiniteScrolling: .off, showItemsOnEmptyQuery: true)
    interactor.connectSearcher(searcher)

    let exp = expectation(description: "Hits updated")
    interactor.onResultsUpdated.subscribe(with: self) { _, _ in
      exp.fulfill()
    }
    searcher.onResults.fire(makeSearchResponse(hits: [Hit(object: makeJSONHit("h1"))], nbHits: 1))
    waitForExpectations(timeout: 2, handler: .none)
  }

  func testFacetSearcherOnQueryChanged() throws {
    let searcher = try CompositionFacetSearcher(appID: "testAppID",
                                                apiKey: "testApiKey",
                                                compositionID: "composition1",
                                                facetName: "color")
    let exp = expectation(description: "Query change expectation")
    searcher.onQueryChanged.subscribe(with: self) { _, newQuery in
      XCTAssertEqual(newQuery, "re")
      exp.fulfill()
    }
    searcher.query = "re"
    waitForExpectations(timeout: 2, handler: .none)
  }

  func testFacetSearcherFacetListConnection() throws {
    let searcher = try CompositionFacetSearcher(appID: "testAppID",
                                                apiKey: "testApiKey",
                                                compositionID: "composition1",
                                                facetName: "color")
    let interactor = FacetListInteractor()
    interactor.connectFacetSearcher(searcher)

    let exp = expectation(description: "Facet list updated")
    interactor.onItemsChanged.subscribe(with: self) { _, _ in
      exp.fulfill()
    }
    searcher.onResults.fire(makeFacetSearchResponse(facetHits: [FacetHits(value: "red", highlighted: "red", count: 2)]))
    waitForExpectations(timeout: 5, handler: .none)
  }
}
