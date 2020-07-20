//
//  FacetListConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class FacetListConnector: Connection {

  public enum Searcher {
    case singleIndex(SingleIndexSearcher)
    case facet(FacetSearcher)
  }

  public let filterState: FilterState
  public let searcher: Searcher
  public let interactor: FacetListInteractor
  public let attribute: Attribute

  public let filterStateConnection: Connection
  public let searcherConnection: Connection

  internal init(searcher: Searcher,
                filterState: FilterState,
                interactor: FacetListInteractor = .init(),
                attribute: Attribute,
                operator: RefinementOperator,
                groupName: String? = nil) {

    self.filterState = filterState
    self.searcher = searcher
    self.interactor = interactor
    self.attribute = attribute

    self.filterStateConnection = interactor.connectFilterState(filterState,
                                                               with: attribute,
                                                               operator: `operator`,
                                                               groupName: groupName)
    switch searcher {
    case .facet(let facetSearcher):
      searcherConnection = interactor.connectFacetSearcher(facetSearcher)

    case .singleIndex(let singleIndexSearcher):
      searcherConnection = interactor.connectSearcher(singleIndexSearcher, with: attribute)
    }

  }

  public convenience init(searcher: SingleIndexSearcher,
                          filterState: FilterState,
                          attribute: Attribute,
                          operator: RefinementOperator,
                          groupName: String? = nil,
                          interactor: FacetListInteractor = .init()) {
    self.init(searcher: .singleIndex(searcher),
              filterState: filterState,
              interactor: interactor,
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
  }

  public convenience init(searcher: FacetSearcher,
                          filterState: FilterState,
                          attribute: Attribute,
                          operator: RefinementOperator,
                          groupName: String? = nil,
                          interactor: FacetListInteractor = .init()) {
    self.init(searcher: .facet(searcher),
              filterState: filterState,
              interactor: interactor,
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
  }

  public convenience init(searcher: SingleIndexSearcher,
                          filterState: FilterState,
                          attribute: Attribute,
                          facets: [Facet],
                          selectionMode: SelectionMode,
                          operator: RefinementOperator,
                          groupName: String? = nil) {
    self.init(searcher: .singleIndex(searcher),
              filterState: filterState,
              interactor: .init(facets: facets, selectionMode: selectionMode),
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
  }

  public convenience init(searcher: FacetSearcher,
                          filterState: FilterState,
                          attribute: Attribute,
                          facets: [Facet],
                          selectionMode: SelectionMode,
                          operator: RefinementOperator,
                          groupName: String? = nil) {
    self.init(searcher: .facet(searcher),
              filterState: filterState,
              interactor: .init(facets: facets, selectionMode: selectionMode),
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
  }

  public func connect() {
    filterStateConnection.connect()
    searcherConnection.connect()
  }

  public func disconnect() {
    filterStateConnection.disconnect()
    searcherConnection.disconnect()
  }

}
