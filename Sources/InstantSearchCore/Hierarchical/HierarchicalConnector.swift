//
//  HierarchicalConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class HierarchicalConnector {

  /// Searcher that handles your searches
  public let searcher: SingleIndexSearcher
  
  /// Current state of the filters.
  public let filterState: FilterState
  
  /// Logic applied to the hierarchical facets.
  public let interactor: HierarchicalInteractor

  /// Connection between searcher and interactor
  public let searcherConnection: Connection
  
  /// Connection between filter state and interactor
  public let filterStateConnection: Connection
  
  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]
  
  /**
   - Parameters:
     - searcher: Searcher that handles your searches.
     - filterState: Filter state that will hold your filters.
     - hierarchicalAttributes: The names of the hierarchical attributes that we need to target, in ascending order.
     - separator: The string separating the facets in the hierarchical facets.
  */
  public init(searcher: SingleIndexSearcher,
              filterState: FilterState,
              hierarchicalAttributes: [Attribute],
              separator: String) {
    self.searcher = searcher
    self.filterState = filterState
    self.interactor = HierarchicalInteractor(hierarchicalAttributes: hierarchicalAttributes, separator: separator)
    self.searcherConnection = interactor.connectSearcher(searcher: searcher)
    self.filterStateConnection = interactor.connectFilterState(filterState)
    self.controllerConnections = []
  }

}

extension HierarchicalConnector {
  
  public typealias HierarchicalPresenter<Output> = ([HierarchicalFacet]) -> Output
  
  /**
   - Parameters:
     - searcher: Searcher that handles your searches.
     - filterState: Filter state that will hold your filters.
     - hierarchicalAttributes: The names of the hierarchical attributes that we need to target, in ascending order.
     - separator: The string separating the facets in the hierarchical facets.
     - controller: Controller that interfaces with a concrete hierarchical view
     - presenter: Presenter defining how hierarchical facets appears in the controller
  */
  public convenience init<Controller: HierarchicalController, Output>(searcher: SingleIndexSearcher,
                                                                      filterState: FilterState,
                                                                      hierarchicalAttributes: [Attribute],
                                                                      separator: String,
                                                                      controller: Controller,
                                                                      presenter: @escaping HierarchicalPresenter<Output>) where Controller.Item == Output {
    self.init(searcher: searcher,
              filterState: filterState,
              hierarchicalAttributes: hierarchicalAttributes,
              separator: separator)
    connectController(controller, presenter: presenter)
  }

  
  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller that interfaces with a concrete hierarchical view
     - presenter: Presenter defining how hierarchical facets appears in the controller
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: HierarchicalController, Output>(_ controller: Controller,
                                                                                        presenter: @escaping HierarchicalPresenter<Output>) -> Hierarchical.ControllerConnection<Controller, Output> {
    let connection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(connection)
    return connection
  }
  
}

extension HierarchicalConnector: Connection {
  
  public func connect() {
    searcherConnection.connect()
    filterStateConnection.connect()
  }

  public func disconnect() {
    searcherConnection.disconnect()
    filterStateConnection.disconnect()
  }
  
}
