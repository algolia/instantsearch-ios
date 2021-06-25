//
//  FilterListConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

public
extension FilterListConnector {

  /**
  Init with explicit interactor and controller
  - Parameters:
    - filterState: FilterState that holds your filters
    - interactor: External filter list interactor
    - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state
    - groupName: Filter group name
    - controller: Controller interfacing with a concrete filter list view
  */
  convenience init<Controller: SelectableListController>(filterState: FilterState,
                                                         interactor: FilterListInteractor<Filter>,
                                                         `operator`: RefinementOperator,
                                                         groupName: String,
                                                         controller: Controller) where Controller.Item == Filter {
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName)
    connectController(controller)
  }

  /**
  Init with implicit interactor and controller
  - Parameters:
    - filterState: FilterState that holds your filters
    - filters: List of filters to display
    - selectionMode: Whether a user can select .single or .multiple values
    - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state
    - groupName: Filter group name
    - controller: Controller interfacing with a concrete filter list view
  */
  convenience init<Controller: SelectableListController>(filterState: FilterState,
                                                         filters: [Filter],
                                                         selectionMode: SelectionMode,
                                                         `operator`: RefinementOperator,
                                                         groupName: String,
                                                         controller: Controller) where Controller.Item == Filter {
    let interactor = FilterListInteractor<Filter>(items: filters,
                                                  selectionMode: selectionMode)
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName)
    connectController(controller)
  }

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller interfacing with a concrete filter list view
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: SelectableListController>(_ controller: Controller) -> FilterListControllerConnection<Filter, Controller> where Controller.Item == Filter {
    let connection = interactor.connectController(controller)
    controllerConnections.append(connection)
    return connection
  }

}
