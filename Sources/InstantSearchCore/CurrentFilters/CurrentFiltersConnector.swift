//
//  CurrentFiltersConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that displays the current refinements and let users remove them.
public class CurrentFiltersConnector {

  /// Filter state holding your filters
  public let filterState: FilterState
  
  /// When specified, only display current refinements matching these filter group ids
  public let groupIDs: Set<FilterGroup.ID>?
  
  /// Logic applied to the current filters
  public let interactor: CurrentFiltersInteractor

  /// Connection between interactor and filter state
  public let filterStateConnection: Connection
  
  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
   - Parameters:
     - filterState: Filter state holding your filters
     - groupIDs: When specified, only display current refinements matching these filter group ids
     - interactor: Logic applied to the current filters
  */
  public init(filterState: FilterState,
              groupIDs: Set<FilterGroup.ID>? = nil,
              interactor: CurrentFiltersInteractor = .init()) {
    self.filterState = filterState
    self.groupIDs = groupIDs
    self.interactor = interactor
    self.filterStateConnection = interactor.connectFilterState(filterState, filterGroupIDs: groupIDs)
    self.controllerConnections = []
  }
  
}

extension CurrentFiltersConnector {
  
  /**
   Initalizer with an immediate controller connection
   - Parameters:
     - filterState: Filter state holding your filters
     - groupIDs: When specified, only display current refinements matching these filter group ids
     - interactor: Logic applied to the current filters
     - controller: Controller interfacing with current filters
     - presenter: Presenter defining how a filter appears in the controller
  */
  public convenience init<Controller: ItemListController>(filterState: FilterState,
                                                          groupIDs: Set<FilterGroup.ID>? = nil,
                                                          interactor: CurrentFiltersInteractor = .init(),
                                                          controller: Controller? = nil,
                                                          presenter: @escaping Presenter<Filter, String> = DefaultPresenter.Filter.present) where Controller.Item == FilterAndID {
    self.init(filterState: filterState, groupIDs: groupIDs, interactor: interactor)
    if let controller = controller {
      connectController(controller, presenter: presenter)
    }
  }
  
  /**
   - Parameters:
     - controller: Controller interfacing with current filters
     - presenter: Presenter defining how a filter appears in the controller
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: ItemListController>(_ controller: Controller,
                                                                            presenter: @escaping Presenter<Filter, String> = DefaultPresenter.Filter.present) -> some Connection where Controller.Item == FilterAndID {
    let connection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(connection)
    return connection
  }

}

extension CurrentFiltersConnector: Connection {
  
  public func connect() {
    filterStateConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    filterStateConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }
  
}
