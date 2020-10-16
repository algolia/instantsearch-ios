//
//  FilterClearConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

public extension FilterClearConnector {

  /**
   - Parameters:
     - filterState: FilterState that holds your filters
     - interactor: Logic applied to Clear Fitlers
     - clearMode: Whether we should clear the `specified` filters or all filters `except` them
     - filterGroupIDs: GroupIDs of filters to clear. All filters will be cleared if unspecified.
     - controller: Controller interfacing with a concrete clear refinement view
   */
  convenience init(filterState: FilterState,
                   interactor: FilterClearInteractor = .init(),
                   clearMode: ClearMode = .specified,
                   filterGroupIDs: [FilterGroup.ID]? = nil,
                   controller: FilterClearController) {
    self.init(filterState: filterState,
              interactor: interactor,
              clearMode: clearMode,
              filterGroupIDs: filterGroupIDs)
    connectController(controller)
  }

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller interfacing with a concrete clear refinement view
   - Returns: Established connection
  */
  @discardableResult func connectController(_ controller: FilterClearController) -> FilterClearInteractor.ControllerConnection {
    let connection = interactor.connectController(controller)
    controllerConnections.append(connection)
    return connection
  }

}
