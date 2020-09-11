//
//  FilterListConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Components that display a list of filters.
public class FilterListConnector<Filter: FilterType & Hashable> {

  /// Filter state that will hold your filters.
  public let filterState: FilterState
  
  /// The logic applied to the filters
  public let interactor: FilterListInteractor<Filter>
  
  /// Connection between interactor and filter state
  public let connectionFilterState: Connection
  
  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
  Init with explicit interactor
  - Parameters:
    - filterState: Filter state that will hold your filters
    - interactor: External filter list interactor
    - operator: Filter group operator
    - groupName: Filter group name
  */
  public init(filterState: FilterState,
              interactor: FilterListInteractor<Filter>,
              `operator`: RefinementOperator,
              groupName: String) {
    self.filterState = filterState
    self.interactor = interactor
    self.connectionFilterState = interactor.connectFilterState(filterState,
                                                               operator: `operator`,
                                                               groupName: groupName)
    self.controllerConnections = []
  }
  
  /**
  Init with implicit interactor
  - Parameters:
    - filterState: Filter state that will hold your filters
    - filters: List of filters to display
    - selectionMode: Whether the list can have single or multiple selections
    - operator: Filter group operator
    - groupName: Filter group name
  */
  public convenience init(filterState: FilterState,
                          filters: [Filter],
                          selectionMode: SelectionMode,
                          `operator`: RefinementOperator,
                          groupName: String) {
    let interactor = FilterListInteractor<Filter>.init(items: filters,
                                                       selectionMode: selectionMode)
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName)
  }
  
}

extension FilterListConnector {
  
  /**
  Init with explicit interactor and controller
  - Parameters:
    - filterState: Filter state that will hold your filters
    - interactor: External filter list interactor
    - operator: Filter group operator
    - groupName: Filter group name
    - controller: Controller interfacing with a filter list view
  */
  public convenience init<Controller: SelectableListController>(filterState: FilterState,
              interactor: FilterListInteractor<Filter>,
              `operator`: RefinementOperator,
              groupName: String,
              controller: Controller) where Controller.Item == Filter {
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName)
  }
  
  /**
  Init with implicit interactor and controller
  - Parameters:
    - filterState: Filter state that will hold your filters
    - filters: List of filters to display
    - selectionMode: Whether the list can have single or multiple selections
    - operator: Filter group operator
    - groupName: Filter group name
    - controller: Controller interfacing with a filter list view
  */
  public convenience init<Controller: SelectableListController>(filterState: FilterState,
                          filters: [Filter],
                          selectionMode: SelectionMode,
                          `operator`: RefinementOperator,
                          groupName: String,
                          controller: Controller) where Controller.Item == Filter {
    let interactor = FilterListInteractor<Filter>.init(items: filters,
                                                       selectionMode: selectionMode)
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName)
  }
  
  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller interfacing with a filter list view
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: SelectableListController>(_ controller: Controller) -> some Connection where Controller.Item == Filter {
    let connection = interactor.connectController(controller)
    controllerConnections.append(connection)
    return connection
  }
  
}

extension FilterListConnector: Connection {
  
  public func connect() {
    connectionFilterState.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    connectionFilterState.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }
  
}
