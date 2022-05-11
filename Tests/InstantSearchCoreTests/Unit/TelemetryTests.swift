//
//  TelemetryTests.swift
//  
//
//  Created by Vladislav Fitc on 06/10/2021.
//

import Foundation
@testable import InstantSearchCore
import InstantSearchInsights
import XCTest
import InstantSearchTelemetry

class TelemetryTests: XCTestCase {
  
  override func setUp() {
    Telemetry.shared.reset()
  }
  
  class TestRequester: HTTPRequester {
    
    var onRequestPerform: (URLRequest) -> Void  = { _ in }
    
    init(onRequestPerform: @escaping (URLRequest) -> Void) {
      self.onRequestPerform = onRequestPerform
    }
    
    struct EmptyError: Error {}
    
    func perform<T>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> TransportTask where T : Decodable {
      self.onRequestPerform(request)
      completion(.failure(EmptyError()))
      return URLSession.shared.dataTask(with: request)
    }
    
  }
  
  let hitsSearcher = HitsSearcher(appID: "", apiKey: "", indexName: "")
  let facetSearcher = FacetSearcher(appID: "", apiKey: "", indexName: "", facetName: "")
  let searchBoxInteractor = SearchBoxInteractor()
  let searchBoxController = TestSearchBoxController()
  let hitsController = TestHitsController<String>()
  let hitsInteractor = HitsInteractor<String>()
  let filterState = FilterState()
  let filter = FacetFilter(attribute: "a", boolValue: true)
  let facet = Facet(value: "f", count: 0, highlighted: nil)
  
  func component(ofType type: TelemetryComponentType) throws -> TelemetryComponent {
    if let component = Telemetry.shared.component(ofType: type) {
      return component
    } else {
      throw TelemetryTestError.componentNotFound(type)
    }
  }
  
  enum TelemetryTestError: Error {
    case componentNotFound(TelemetryComponentType)
  }
  
  func testUserAgents() throws {
    throw XCTSkip()
    
    let expectation1 = expectation(description: "URL request expectation")
    
    _ = HitsSearcher(appID: "", apiKey: "", indexName: "")
    _ = FacetSearcher(appID: "", apiKey: "", indexName: "", facetName: "")
    
    let requester = TestRequester() { request in
      guard let userAgentValue = request.allHTTPHeaderFields?["User-Agent"] else {
        XCTFail("Missing user-agent value")
        expectation1.fulfill()
        return
      }
      guard let schema = TelemetrySchema(userAgentString: userAgentValue) else {
        XCTFail("Cannot build Schema")
        expectation1.fulfill()
        return
      }
      XCTAssertTrue(schema.components.contains(where: { $0.type == .hitsSearcher }))
      XCTAssertTrue(schema.components.contains(where: { $0.type == .facetSearcher }))
      expectation1.fulfill()
    }
    
    let client = SearchClient(configuration: .init(applicationID: "", apiKey: ""),
                              requester: requester)
    
    do {
      try client.index(withName: "indexname").search(query: Query())
    } catch _ {
    }
    
    wait(for: [expectation1], timeout: 5)
    
    _ = FilterState()
    
    let expectation2 = expectation(description: "URL request expectation")
    
    requester.onRequestPerform = { request in
      guard let userAgentValue = request.allHTTPHeaderFields?["User-Agent"] else {
        XCTFail("Missing user-agent value")
        expectation1.fulfill()
        return
      }
      guard let schema = TelemetrySchema(userAgentString: userAgentValue) else {
        XCTFail("Cannot build Schema")
        expectation1.fulfill()
        return
      }
      XCTAssertTrue(schema.components.contains(where: { $0.type == .hitsSearcher }))
      XCTAssertTrue(schema.components.contains(where: { $0.type == .facetSearcher }))
      XCTAssertTrue(schema.components.contains(where: { $0.type == .filterState }))
      expectation2.fulfill()
    }
    
    do {
      try client.index(withName: "indexname").search(query: Query())
    } catch _ {
    }
    
    wait(for: [expectation2], timeout: 5)
    
  }
  
}

//MARK: - Current filters
extension TelemetryTests {
  
  func testCurrentFiltersConnector() throws {
    _ = CurrentFiltersConnector(filterState: filterState)
    let component = try component(ofType: .currentFilters)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testCurrentFiltersConnectorGroupIDs() throws {
    _ = CurrentFiltersConnector(filterState: filterState,
                                groupIDs: [
                                  .and(name: "a"),
                                  .or(name: "b", filterType: .facet)
                                ])
    let component = try component(ofType: .currentFilters)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.groupIds])
  }
  
  func testCurrentFiltersInteractor() throws {
    _ = CurrentFiltersInteractor()
    let component = try component(ofType: .currentFilters)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testCurrentFiltersInteractorItems() throws {
    _ = CurrentFiltersInteractor(items: [
      .init(filter: .facet(.init(attribute: "a", value: false)),
            id: .and(name: "a"))
    ])
    let component = try component(ofType: .currentFilters)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.items])
  }
  
  
}

//MARK: - Search connector
extension TelemetryTests {
  
  func testSearchConnector() throws {
    _ = SearchConnector(searcher: hitsSearcher,
                        searchBoxInteractor: searchBoxInteractor,
                        searchBoxController: searchBoxController,
                        hitsInteractor: hitsInteractor,
                        hitsController: hitsController)
    let component = try component(ofType: .hitsSearcher)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testSearchConnectorFilterState() throws {
    _ = SearchConnector(searcher: hitsSearcher,
                        searchBoxInteractor: searchBoxInteractor,
                        searchBoxController: searchBoxController,
                        hitsInteractor: hitsInteractor,
                        hitsController: hitsController,
                        filterState: filterState)
    let component = try component(ofType: .hitsSearcher)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.filterState])
  }
  
  func testSearchConnectorImplicitSearcher() throws {
    _ = SearchConnector(appID: "",
                        apiKey: "",
                        indexName: "",
                        searchBoxController: searchBoxController,
                        hitsInteractor: hitsInteractor,
                        hitsController: hitsController,
                        filterState: filterState)
    let component = try component(ofType: .hitsSearcher)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.apiKey, .appID, .client, .indexName, .filterState])
  }
  
  func AssertEquivalent<S: Sequence>(_ s1: S, _ s2: S) where S.Element: Hashable {
    XCTAssertEqual(Set(s1), Set(s2))
  }
  
}

//MARK: - Dynamic facets
extension TelemetryTests {
  
  func testDynamicFacetsListInteractor() throws {
    _ = DynamicFacetListInteractor()
    let component = try component(ofType: .dynamicFacets)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testDynamicFacetsListInteractorOrderedFacets() throws {
    _ = DynamicFacetListInteractor(orderedFacets: [.init(attribute: "a", facets: [facet])])
    let component = try component(ofType: .dynamicFacets)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.orderedFacets])
  }
  
  func testDynamicFacetsListInteractorSelections() throws {
    _ = DynamicFacetListInteractor(selections: ["a": ["b"]])
    let component = try component(ofType: .dynamicFacets)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.selections])
  }
  
  func testDynamicFacetsListInteractorSelectionModeForAttribute() throws {
    _ = DynamicFacetListInteractor(selectionModeForAttribute: ["a": .multiple])
    let component = try component(ofType: .dynamicFacets)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.selectionModeForAttribute])
  }
  
  func testDynamicFacetsListConnector() throws {
    _ = DynamicFacetListConnector(searcher: hitsSearcher)
    let component = try component(ofType: .dynamicFacets)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testDynamicFacetsListConnectorOrderedFacets() throws {
    _ = DynamicFacetListConnector(searcher: hitsSearcher,
                                  orderedFacets: [.init(attribute: "a", facets: [facet])])
    let component = try component(ofType: .dynamicFacets)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.orderedFacets])
  }
  
  func testDynamicFacetsListConnectorSelections() throws {
    _ = DynamicFacetListConnector(searcher: hitsSearcher,
                                  selections: ["a": ["b"]])
    let component = try component(ofType: .dynamicFacets)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.selections])
  }
  
  func testDynamicFacetsListConnectorSelectionModeForAttribute() throws {
    _ = DynamicFacetListConnector(searcher: hitsSearcher,
                                  selectionModeForAttribute: ["a": .multiple])
    let component = try component(ofType: .dynamicFacets)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.selectionModeForAttribute])
  }
  
  func testDynamicFacetsListConnectorFilterGroupForAttribute() throws {
    _ = DynamicFacetListConnector(searcher: hitsSearcher,
                                  filterGroupForAttribute: ["a": ("ag", .or)])
    let component = try component(ofType: .dynamicFacets)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.filterGroupForAttribute])
  }
  
}

//MARK: - Facet list
extension TelemetryTests {
  
  func testFacetListInteractor() throws {
    _ = FacetListInteractor()
    let component = try component(ofType: .facetList)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testFacetListInteractorFacets() throws {
    _ = FacetListInteractor(facets: [facet])
    let component = try component(ofType: .facetList)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.facets])
  }
  
  func testFacetListInteractorSelectionMode() throws {
    _ = FacetListInteractor(selectionMode: .single)
    let component = try component(ofType: .facetList)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.selectionMode])
  }
  
  func testFacetListConnectorFacetSearcher() throws {
    _ = FacetListConnector(searcher: facetSearcher,
                           attribute: "",
                           operator: .and)
    let component = try component(ofType: .facetList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.facetSearcher])
  }
  
  func testFacetListConnectorFacetSearcherGroupName() throws {
    _ = FacetListConnector(searcher: facetSearcher,
                           attribute: "",
                           operator: .and,
                           groupName: "")
    let component = try component(ofType: .facetList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.groupName, .facetSearcher])
  }
  
  func testFacetListConnectorFacetSearcherFacets() throws {
    _ = FacetListConnector(searcher: facetSearcher,
                           attribute: "",
                           selectionMode: .single,
                           facets: [facet],
                           operator: .and)
    let component = try component(ofType: .facetList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.facets, .selectionMode, .facetSearcher])
  }
  
  func testFacetListConnectorHitsSearcher() throws {
    _ = FacetListConnector(searcher: hitsSearcher,
                           attribute: "",
                           operator: .and)
    let component = try component(ofType: .facetList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.hitsSearcher])
  }
  
  func testFacetListConnectorHitsSearcherGroupName() throws {
    _ = FacetListConnector(searcher: hitsSearcher,
                           attribute: "",
                           operator: .and,
                           groupName: "")
    let component = try component(ofType: .facetList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.groupName, .hitsSearcher])
  }
  
  func testFacetListConnectorHitsSearcherFacets() throws {
    _ = FacetListConnector(searcher: hitsSearcher,
                           attribute: "",
                           selectionMode: .single,
                           facets: [facet],
                           operator: .and)
    let component = try component(ofType: .facetList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.facets, .selectionMode, .hitsSearcher])
  }
  
}

//MARK: - Filter clear
extension TelemetryTests {
  
  func testFilterClearInteractor() throws {
    _ = FilterClearInteractor()
    let component = try component(ofType: .filterClear)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testFilterClearConnector() throws {
    _ = FilterClearConnector(filterState: .init())
    let component = try component(ofType: .filterClear)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testFilterClearConnectorSetClearMode() throws {
    _ = FilterClearConnector(filterState: .init(),
                             clearMode: .except)
    let component = try component(ofType: .filterClear)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.clearMode])
  }
  
  func testFilterClearConnectorSetFilterGroupIDs() throws {
    _ = FilterClearConnector(filterState: .init(),
                             filterGroupIDs: [
                              .and(name: "a"),
                              .or(name: "b", filterType: .facet)
                             ])
    let component = try component(ofType: .filterClear)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.filterGroupIds])
  }
  
}

//MARK: - Filter list
extension TelemetryTests {
  
  func testNumericFilterListInteractor() throws {
    _ = NumericFilterListInteractor()
    let component = try component(ofType: .numericFilterList)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.selectionMode])
  }
  
  func testFacetFiltersListInteractor() throws {
    _ = FacetFilterListInteractor()
    let component = try component(ofType: .facetFilterList)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.selectionMode])
  }
  
  func testTagFiltersListInteractor() throws {
    _ = TagFilterListInteractor()
    let component = try component(ofType: .tagFilterList)
    XCTAssertEqual(component.type, .tagFilterList)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.selectionMode])
  }
  
  func testFilterListConnector() throws {
    _ = FilterListConnector(filterState: filterState,
                            filters: [filter],
                            selectionMode: .multiple,
                            operator: .and,
                            groupName: "group")
    let component = try component(ofType: .facetFilterList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.selectionMode, .filters])
  }
  
  func testNumericFilterListConnector() throws {
    _ = NumericFilterListConnector(filterState: filterState,
                                   operator: .and,
                                   groupName: "group")
    let component = try component(ofType: .numericFilterList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.selectionMode])
  }
  
  func testFacetFiltersListConnector() throws {
    _ = FacetFilterListConnector(filterState: filterState,
                                 operator: .and,
                                 groupName: "group")
    let component = try component(ofType: .facetFilterList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.selectionMode])
  }
  
  func testTagFiltersListConnector() throws {
    _ = TagFilterListConnector(filterState: filterState,
                               operator: .and,
                               groupName: "group")
    let component = try component(ofType: .tagFilterList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.selectionMode])
  }
  
}

//MARK: - Filter State
extension TelemetryTests {
  
  func testFilterState() throws {
    _ = FilterState()
    let component = try component(ofType: .filterState)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testFilterStateCopy() throws {
    _ = FilterState(FilterState())
    let component = try component(ofType: .filterState)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.filterState])
  }
  
}

//MARK: - Hierarchical
extension TelemetryTests {
  
  func testHierarchicalInteractor() throws {
    _ = HierarchicalInteractor(hierarchicalAttributes: [],
                               separator: "")
    let component = try component(ofType: .hierarchicalFacets)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testHierarchicalConnector() throws {
    _ = HierarchicalConnector(searcher: hitsSearcher,
                              filterState: filterState,
                              hierarchicalAttributes: [],
                              separator: "")
    let component = try component(ofType: .hierarchicalFacets)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
}

//MARK: - Hits
extension TelemetryTests {
  
  func testHitsInteractor() throws {
    _ = HitsInteractor<String>()
    let component = try component(ofType: .hits)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testHitsInteractorInfiniteScrolling() throws {
    _ = HitsInteractor<String>(infiniteScrolling: .off)
    let component = try component(ofType: .hits)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.infiniteScrolling])
  }
  
  func testHitsInteractorShowItemsOnEmptyQuery() throws {
    _ = HitsInteractor<String>(showItemsOnEmptyQuery: false)
    let component = try component(ofType: .hits)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.showItemsOnEmptyQuery])
  }
  
  func testHitsConnector() throws {
    _ = HitsConnector<String>(searcher: hitsSearcher)
    let component = try component(ofType: .hits)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testHitsConnectorFilterState() throws {
    _ = HitsConnector<String>(searcher: hitsSearcher,
                              filterState: filterState)
    let component = try component(ofType: .hits)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.filterState])
  }
  
  func testHitsConnectorParams() throws {
    _ = HitsConnector<String>(appID: "",
                              apiKey: "",
                              indexName: "",
                              infiniteScrolling: .off,
                              showItemsOnEmptyQuery: false,
                              filterState: filterState)
    let component = try component(ofType: .hits)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [
      .apiKey,
      .appID,
      .indexName,
      .infiniteScrolling,
      .showItemsOnEmptyQuery,
      .filterState,
    ])
  }
  
}

//MARK: - Loading
extension TelemetryTests {
  
  func testLoadingInteractor() throws {
    _ = LoadingInteractor()
    let component = try component(ofType: .loading)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testLoadingConnector() throws {
    _ = LoadingConnector(searcher: hitsSearcher)
    let component = try component(ofType: .loading)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
}

//MARK: - Number
extension TelemetryTests {
  
  func testNumberFilterInteractor() throws {
    _ = NumberInteractor<Int>()
    let component = try component(ofType: .numberFilter)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testNumberFilterInteractorItem() throws {
    _ = NumberInteractor<Int>(item: 10)
    let component = try component(ofType: .numberFilter)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.number])
  }
  
  func testNumberFilterConnector() throws {
    _ = FilterComparisonConnector<Int>(searcher: hitsSearcher,
                                       filterState: filterState,
                                       attribute: "a",
                                       numericOperator: .greaterThan,
                                       number: 20,
                                       operator: .or)
    let component = try component(ofType: .numberFilter)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testNumberFilterConnectorBounds() throws {
    _ = FilterComparisonConnector<Int>(searcher: hitsSearcher,
                                       filterState: filterState,
                                       attribute: "a",
                                       numericOperator: .greaterThan,
                                       number: 20,
                                       bounds: 0...20,
                                       operator: .or)
    let component = try component(ofType: .numberFilter)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.bounds])
    
  }
  
  func testNumberFilterConnectorGroupName() throws {
    _ = FilterComparisonConnector<Int>(searcher: hitsSearcher,
                                       filterState: filterState,
                                       attribute: "a",
                                       numericOperator: .greaterThan,
                                       number: 20,
                                       operator: .or,
                                       groupName: "a")
    let component = try component(ofType: .numberFilter)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.groupName])
  }
  
  
}

//MARK: - SearchBox
extension TelemetryTests {
  
  func testSearchBoxInteractor() throws {
    _ = SearchBoxInteractor()
    let component = try component(ofType: .searchBox)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testSearchBoxConnector() throws {
    _ = SearchBoxConnector(searcher: hitsSearcher)
    let component = try component(ofType: .searchBox)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testSearchBoxConnectorSearchTriggeringMode() throws {
    _ = SearchBoxConnector(searcher: hitsSearcher,
                           searchTriggeringMode: .searchOnSubmit)
    let component = try component(ofType: .searchBox)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.searchTriggeringMode])
  }
  
}

//MARK: - QueryRuleCustomData
extension TelemetryTests {
  
  func testQueryRuleCustomDataInteractor() throws {
    _ = QueryRuleCustomDataInteractor<String>()
    let component = try component(ofType: .queryRuleCustomData)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testQueryRuleCustomDataInteractorItem() throws {
    _ = QueryRuleCustomDataInteractor<String>(item: "hey")
    let component = try component(ofType: .queryRuleCustomData)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.item])
  }
  
  func testQueryRuleCustomDataConnector() throws {
    _ = QueryRuleCustomDataConnector<String>(searcher: hitsSearcher)
    let component = try component(ofType: .queryRuleCustomData)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
}

//MARK: - Relevant Sort
extension TelemetryTests {
  
  func testRelevantSortInteractor() throws {
    _ = RelevantSortInteractor()
    let component = try component(ofType: .relevantSort)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testRelevantSortInteractorPriority() throws {
    _ = RelevantSortInteractor(priority: .hitsCount)
    let component = try component(ofType: .relevantSort)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.priority])
  }
  
  func testRelevantSortConnector() throws {
    _ = RelevantSortConnector(searcher: hitsSearcher)
    let component = try component(ofType: .relevantSort)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
}

//MARK: - Answers Searcher
extension TelemetryTests {
  
  func testAnswersSearcher() throws {
    _ = AnswersSearcher(applicationID: "",
                        apiKey: "",
                        indexName: "")
    let component = try component(ofType: .answersSearcher)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
}

//MARK: - Facet Searcher
extension TelemetryTests {
  
  func testFacetSearcher() throws {
    _ = FacetSearcher(client: .init(appID: "", apiKey: ""),
                      indexName: "",
                      facetName: "")
    let component = try component(ofType: .facetSearcher)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.client])
  }
  
  func testFacetSearcherParams() throws {
    _ = FacetSearcher(appID: "",
                      apiKey: "",
                      indexName: "",
                      facetName: "")
    let component = try component(ofType: .facetSearcher)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.apiKey, .appID])
  }
  
}

//MARK: - Hits Searcher
extension TelemetryTests {
  
  func testHitsSearcher() throws {
    _ = HitsSearcher(client: .init(appID: "", apiKey: ""),
                     indexName: "")
    let component = try component(ofType: .hitsSearcher)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.client])
  }
  
  func testHitsSearcherParams() throws {
    _ = HitsSearcher(appID: "",
                     apiKey: "",
                     indexName: "")
    let component = try component(ofType: .hitsSearcher)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.apiKey, .appID, .client,])
  }
  
}

//MARK: - Multi Searcher
extension TelemetryTests {
  
  func testMultiSearcher() throws {
    _ = MultiSearcher(appID: "", apiKey: "")
    let component = try component(ofType: .multiSearcher)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
}

//MARK: - Filter toggle
extension TelemetryTests {
  
  func testFilterToggleConnector() throws {
    _ = FilterToggleConnector(filterState: filterState,
                              filter: filter)
    let component = try component(ofType: .filterToggle)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testFilterToggleConnectorParams() throws {
    _ = FilterToggleConnector(filterState: filterState,
                              filter: filter,
                              isSelected: true,
                              operator: .or,
                              groupName: "g")
    let component = try component(ofType: .filterToggle)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.groupName, .operator, .isSelected])
  }
  
}


//MARK: - Segmented filter (filter map)
extension TelemetryTests {
  
  func testSelectableFilterInteractor() throws {
    _ = FilterMapInteractor(items: [0: filter])
    let component = try component(ofType: .filterMap)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testSelectableFilterInteractorSelected() throws {
    _ = FilterMapInteractor(items: [0: filter],
                            selected: 0)
    let component = try component(ofType: .filterMap)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.selected])
  }
  
  func testSelectableFilterConnector() throws {
    _ = FilterMapConnector(searcher: hitsSearcher,
                           filterState: filterState,
                           items: [0: filter],
                           selected: 0,
                           attribute: "",
                           operator: .or)
    let component = try component(ofType: .filterMap)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testSelectableFilterConnectorGroupName() throws {
    _ = FilterMapConnector(searcher: hitsSearcher,
                           filterState: filterState,
                           items: [0: filter],
                           selected: 0,
                           attribute: "",
                           operator: .or,
                           groupName: "g")
    let component = try component(ofType: .filterMap)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.groupName])
  }
  
}

//MARK: - Sort by
extension TelemetryTests {
  
  func testSortByInteractor() throws {
    _ = SortByInteractor(items: [0: "index"])
    let component = try component(ofType: .sortBy)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testSortByInteractorSelected() throws {
    _ = SortByInteractor(items: [0: "index"],
                         selected: 0)
    let component = try component(ofType: .sortBy)
    XCTAssertFalse(component.isConnector)
    XCTAssertEqual(component.parameters, [.selected])
  }
  
  
  func testSortByConnector() throws {
    _ = SortByConnector(searcher: hitsSearcher,
                        indicesNames: ["index"])
    let component = try component(ofType: .sortBy)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testSortByConnectorSelected() throws {
    _ = SortByConnector(searcher: hitsSearcher,
                        indicesNames: ["index"],
                        selected: 0)
    let component = try component(ofType: .sortBy)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.selected])
  }
  
}

//MARK: - Stats
extension TelemetryTests {
  
  func testStatsInteractor() throws {
    _ = StatsInteractor()
    let component = try component(ofType: .stats)
    XCTAssertFalse(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testStatsConnector() throws {
    _ = StatsConnector(searcher: hitsSearcher)
    let component = try component(ofType: .stats)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
}


extension TelemetrySchema {
  
  init?(userAgentString: String) {
    let telemetryPrefix = "telemetry: "
    guard let telemetryRange = userAgentString.range(of: "\(telemetryPrefix).+==", options: .regularExpression) else {
      return nil
    }
    let telemetryBase64 = String(userAgentString[telemetryRange].dropFirst(telemetryPrefix.count))
    guard let data = Data(base64Encoded: telemetryBase64) else {
      return nil
    }
    guard let schema = try? TelemetrySchema(serializedData: data) else {
      return nil
    }
    self = schema
  }
  
}
