//
//  FacetListConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that displays facets, and lets the user refine the search results by filtering on specific values.
///
/// [Documentation](https://www.algolia.com/doc/api-reference/widgets/refinement-list/ios/)
public class FacetListConnector {

  /// Searcher that handles your searches.
  public let searcher: Searcher

  /// FilterState that holds your filters
  public let filterState: FilterState

  /// Logic applied to the facets
  public let interactor: FacetListInteractor

  /// Attribute to filter
  public let attribute: Attribute

  /// Connection between interactor and filter state
  public let filterStateConnection: Connection

  /// Connection between interactor and searcher
  public let searcherConnection: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  internal init(searcher: Searcher,
                filterState: FilterState = .init(),
                interactor: FacetListInteractor = .init(),
                attribute: Attribute,
                operator: RefinementOperator,
                groupName: String?) {
    self.filterState = filterState
    self.searcher = searcher
    self.interactor = interactor
    self.attribute = attribute

    self.filterStateConnection = interactor.connectFilterState(filterState,
                                                               with: attribute,
                                                               operator: `operator`,
                                                               groupName: groupName)

    self.controllerConnections = []

    switch searcher {
    case .facet(let facetSearcher):
      searcherConnection = interactor.connectFacetSearcher(facetSearcher)

    case .hits(let hitsSearcher):
      searcherConnection = interactor.connectSearcher(hitsSearcher, with: attribute)
    }

  }

}

extension FacetListConnector: Connection {

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

extension FacetListConnector {

  public enum Searcher {
    case hits(HitsSearcher)
    case facet(FacetSearcher)
  }

}
