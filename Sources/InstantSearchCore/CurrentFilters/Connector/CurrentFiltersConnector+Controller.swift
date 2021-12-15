//
//  CurrentFiltersConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

public extension CurrentFiltersConnector {

  /**
   Initalizer with an immediate controller connection
   - Parameters:
     - filterState: FilterState that holds your filters
     - groupIDs: When specified, only display current filters matching these filter group ids
     - interactor: Logic applied to the current filters
     - controller: Controller interfacing with a concrete current filters view
     - presenter: Presenter defining how a filter appears in the controller
  */
  convenience init<Controller: ItemListController>(filterState: FilterState,
                                                   groupIDs: Set<FilterGroup.ID>? = nil,
                                                   interactor: CurrentFiltersInteractor = .init(),
                                                   controller: Controller? = nil,
                                                   presenter: @escaping Presenter<Filter, String> = DefaultPresenter.Filter.present) where Controller.Item == FilterAndID {
    self.init(filterState: filterState,
              groupIDs: groupIDs,
              interactor: interactor)
    if let controller = controller {
      connectController(controller, presenter: presenter)
    }
  }

  /**
   Establishes a connection with the controller using the provided presentation logic
   - Parameters:
     - controller: Controller interfacing with a concrete current filters view
     - presenter: Presenter defining how a filter appears in the controller
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: ItemListController>(_ controller: Controller,
                                                                            presenter: @escaping Presenter<Filter, String> = DefaultPresenter.Filter.present) -> CurrentFiltersInteractor.ControllerConnection<Controller> where Controller.Item == FilterAndID {
    let connection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(connection)
    return connection
  }

}
