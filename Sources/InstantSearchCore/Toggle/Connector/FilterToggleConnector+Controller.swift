//
//  FilterToggleConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

public extension FilterToggleConnector {

  /**
   - Parameters:
     - filterState: FilterState that holds your filters
     - filter: Filter to toggle
     - isSelected: Whether the filter is initially selected
     - operator: Whether the filter is added to a conjuncitve(`and`) or a disjuncitve (`or`) group in the filter state.
     - groupName: Filter group name in the filter state
     - controller: Controller interfacing with a concrete toggle filter view
   */
  convenience init<Controller: SelectableController>(filterState: FilterState,
                                                     filter: Filter,
                                                     isSelected: Bool = false,
                                                     operator: RefinementOperator = .and,
                                                     groupName: String? = nil,
                                                     controller: Controller) where Controller.Item == Filter {
    let interactor = SelectableInteractor(item: filter)
    interactor.isSelected = isSelected
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName)
    connectController(controller)
  }

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller interfacing with a concrete toggle filter view
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: SelectableController>(_ controller: Controller) -> FilterToggle.ControllerConnection<Filter, Controller> where Controller.Item == Filter {
    let connection = interactor.connectController(controller)
    controllerConnections.append(connection)
    return connection
  }

}
