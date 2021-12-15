//
//  DynamicFacetListConnector.swift
//  
//
//  Created by Vladislav Fitc on 17/06/2021.
//

import Foundation

/// Component that displays automatically ordered facets, their ordered values, and lets the user refine the search results by filtering on specific values.

public class DynamicFacetListConnector<Searcher: SearchResultObservable> where Searcher.SearchResult == SearchResponse {

  /// Searcher that handles your searches.
  public let searcher: Searcher

  /// FilterState that holds your filters
  public let filterState: FilterState

  /// Logic applied to the facets
  public let interactor: DynamicFacetListInteractor

  /// Connection between interactor and filter state
  public let filterStateConnection: Connection

  /// Connection between interactor and searcher
  public let searcherConnection: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
  - parameters:
    - searcher: Searcher that handles your searches
    - filterState: FilterState that holds your filters
    - interactor: External dynamic facet list interactor
    - filterGroupForAttribute: Mapping between a facet attribute and a descriptor of a filter group where the corresponding facet filters stored in the filter state.
   
  If no filter group descriptor provided, the filters for attribute will be automatically stored in the conjunctive (`and`)  group with the facet attribute name.
  */
  public init(searcher: Searcher,
              filterState: FilterState = .init(),
              interactor: DynamicFacetListInteractor,
              filterGroupForAttribute: [Attribute: FilterGroupDescriptor] = [:]) {
    self.searcher = searcher
    self.filterState = filterState
    self.interactor = interactor
    self.controllerConnections = []
    searcherConnection = interactor.connectSearcher(searcher)
    filterStateConnection = interactor.connectFilterState(filterState,
                                                          filterGroupForAttribute: filterGroupForAttribute)
    Telemetry.shared.traceConnector(type: .dynamicFacets,
                                    parameters: [
                                      filterGroupForAttribute.isEmpty ? .none : .filterGroupForAttribute
                                    ])
  }

  /**
  - parameters:
    - searcher: Searcher that handles your searches
    - filterState: FilterState that holds your filters
    - orderedFacets: Ordered list of attributed facets
    - selections: Mapping between a facet attribute and a set of selected  facet values
    - selectionModeForAttribute: Mapping between a facet attribute and a facet values selection mode. If not provided, the default selection mode is .single.
    - filterGroupForAttribute: Mapping between a facet attribute and a descriptor of a filter group where the corresponding facet filters stored in the filter state.
   
  If no filter group descriptor provided, the filters for attribute will be automatically stored in the conjunctive (`and`)  group with the facet attribute name.
  */
  public convenience init(searcher: Searcher,
                          filterState: FilterState = .init(),
                          orderedFacets: [AttributedFacets] = [],
                          selections: [Attribute: Set<String>] = [:],
                          selectionModeForAttribute: [Attribute: SelectionMode] = [:],
                          filterGroupForAttribute: [Attribute: FilterGroupDescriptor] = [:]) {
    let interactor = DynamicFacetListInteractor(orderedFacets: orderedFacets,
                                                selections: selections,
                                                selectionModeForAttribute: selectionModeForAttribute)
    self.init(searcher: searcher,
              filterState: filterState,
              interactor: interactor,
              filterGroupForAttribute: filterGroupForAttribute)
    Telemetry.shared.traceConnector(type: .dynamicFacets,
                                    parameters: [
                                      orderedFacets.isEmpty ? .none : .orderedFacets,
                                      selections.isEmpty ? .none : .selections,
                                      selectionModeForAttribute.isEmpty ? .none : .selectionModeForAttribute,
                                      filterGroupForAttribute.isEmpty ? .none : .filterGroupForAttribute
                                    ])
  }

}

extension DynamicFacetListConnector: Connection {

  public func connect() {
    filterStateConnection.connect()
    searcherConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    filterStateConnection.disconnect()
    searcherConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}
