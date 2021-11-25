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


class TelemetryTests: XCTestCase {
  
  var schema: TelemetrySchema {
    return Telemetry.shared.schema
  }
  
  override func setUp() {
    Telemetry.shared.schema.components.removeAll()
  }

  func testMaxSize() {
    let schema = TelemetrySchema.with {
      $0.components = TelemetryComponentType.allCases.map { type in
        TelemetryComponent.with { w in
          w.type = type
          w.isConnector = true
          w.parameters = TelemetryComponentParams.allCases
        }
      }
    }
    let data = try! schema.serializedData()
    print(data.base64EncodedString())
    print(data.count)
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
  let queryInputInteractor = QueryInputInteractor()
  let queryInputController = TestQueryInputController()
  let hitsController = TestHitsController<String>()
  let hitsInteractor = HitsInteractor<String>()
  let filterState = FilterState()
  
  func component(ofType type: TelemetryComponentType) throws -> TelemetryComponent {
    if let component = Telemetry.shared.components[type] {
      return component
    } else {
      throw TelemetryTestError.componentNotFound(type)
    }
  }
  
  enum TelemetryTestError: Error {
    case componentNotFound(TelemetryComponentType)
  }
  
  func testUserAgents() throws {
    
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
                        queryInputInteractor: queryInputInteractor,
                        queryInputController: queryInputController,
                        hitsInteractor: hitsInteractor,
                        hitsController: hitsController)
    let component = try component(ofType: .hitsSearcher)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testSearchConnectorFilterState() throws {
    _ = SearchConnector(searcher: hitsSearcher,
                        queryInputInteractor: queryInputInteractor,
                        queryInputController: queryInputController,
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
                        queryInputController: queryInputController,
                        hitsInteractor: hitsInteractor,
                        hitsController: hitsController,
                        filterState: filterState)
    let component = try component(ofType: .hitsSearcher)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.appID, .apiKey, .indexName, .filterState])
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
    _ = DynamicFacetListInteractor(orderedFacets: [.init(attribute: "a", facets: [])])
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
                                  orderedFacets: [.init(attribute: "a", facets: [])])
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
    _ = FacetListInteractor(facets: [.init(value: "", count: 10, highlighted: nil)])
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
    XCTAssertEqual(component.parameters, [.facetSearcherParameter])
  }
  
  func testFacetListConnectorFacetSearcherGroupName() throws {
    _ = FacetListConnector(searcher: facetSearcher,
                           attribute: "",
                           operator: .and,
                           groupName: "")
    let component = try component(ofType: .facetList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.facetSearcherParameter, .groupName])
  }
  
  func testFacetListConnectorFacetSearcherFacets() throws {
    _ = FacetListConnector(searcher: facetSearcher,
                           attribute: "",
                           selectionMode: .single,
                           facets: [.init(value: "", count: 0, highlighted: nil)],
                           operator: .and)
    let component = try component(ofType: .facetList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.facetSearcherParameter, .facets])
  }
  
  func testFacetListConnectorHitsSearcher() throws {
    _ = FacetListConnector(searcher: hitsSearcher,
                           attribute: "",
                           operator: .and)
    let component = try component(ofType: .facetList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.hitsSearcherParameter])
  }
  
  func testFacetListConnectorHitsSearcherGroupName() throws {
    _ = FacetListConnector(searcher: hitsSearcher,
                           attribute: "",
                           operator: .and,
                           groupName: "")
    let component = try component(ofType: .facetList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.hitsSearcherParameter, .groupName])
  }
  
  func testFacetListConnectorHitsSearcherFacets() throws {
    _ = FacetListConnector(searcher: hitsSearcher,
                           attribute: "",
                           selectionMode: .single,
                           facets: [.init(value: "", count: 0, highlighted: nil)],
                           operator: .and)
    let component = try component(ofType: .facetList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.hitsSearcherParameter, .facets])
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
                            filters: [
                              FacetFilter(attribute: "a", boolValue: true)
                            ],
                            selectionMode: .multiple,
                            operator: .and,
                            groupName: "group")
    let component = try component(ofType: .facetFilterList)
    XCTAssertTrue(component.isConnector)
    XCTAssertEqual(component.parameters, [.filters, .selectionMode])
  }
  
  func testNumericFilterListConnector() throws {
    _ = NumericFilterListConnector(filterState: filterState,
                                   operator: .and,
                                   groupName: "group")
    let component = try component(ofType: .numericFilterList)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testFacetFiltersListConnector() throws {
    _ = FacetFilterListConnector(filterState: filterState,
                                 operator: .and,
                                 groupName: "group")
    let component = try component(ofType: .facetFilterList)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
  }
  
  func testTagFiltersListConnector() throws {
    _ = TagFilterListConnector(filterState: filterState,
                               operator: .and,
                               groupName: "group")
    let component = try component(ofType: .tagFilterList)
    XCTAssertTrue(component.isConnector)
    XCTAssertTrue(component.parameters.isEmpty)
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
}

//MARK: - Loading
extension TelemetryTests {
}

//MARK: - Number
extension TelemetryTests {
}

//MARK: - QueryInput
extension TelemetryTests {
}

//MARK: - QueryRuleCustomData
extension TelemetryTests {
}

//MARK: - Relevant Sort
extension TelemetryTests {
}

//MARK: - Answers Searcher
extension TelemetryTests {
}

//MARK: - Facet Searcher
extension TelemetryTests {
}

//MARK: - Hits Searcher
extension TelemetryTests {
}

//MARK: - Multi Searcher
extension TelemetryTests {
}

//MARK: - Filter toggle
extension TelemetryTests {
}

//MARK: - Sort by
extension TelemetryTests {
}

//MARK: - Stats
extension TelemetryTests {
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
