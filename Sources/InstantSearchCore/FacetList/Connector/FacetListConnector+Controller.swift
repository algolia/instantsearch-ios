//
//  FacetListConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

// MARK: - Convenient controller connectivity

public extension FacetListConnector {

  internal convenience init<Controller: FacetListController>(searcher: Searcher,
                                                             filterState: FilterState = .init(),
                                                             interactor: FacetListInteractor = .init(),
                                                             controller: Controller,
                                                             presenter: SelectableListPresentable?,
                                                             attribute: Attribute,
                                                             operator: RefinementOperator,
                                                             groupName: String?) {
    self.init(searcher: searcher,
              filterState: filterState,
              interactor: interactor,
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
    connectController(controller, with: presenter)
  }

  /**
   Establishes a connection with the controller using the provided presentation logic
   - Parameters:
     - controller: Controller interfacing with a concrete facet list view
     - presenter: Presenter defining how a facet appears in the controller
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: FacetListController>(_ controller: Controller,
                                                                             with presenter: SelectableListPresentable? = nil) -> FacetListConnector.ControllerConnection<Controller> {
    let connection = interactor.connectController(controller, with: presenter)
    controllerConnections.append(connection)
    return connection
  }

}
