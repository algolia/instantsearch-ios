//
//  SwitchIndexConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 12/09/2021.
//

import Foundation

public extension SwitchIndexConnector {
  
  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: Business logic that handles  index name switching
     - controller: Controller interfacing with a concrete switch index view
   */
  convenience init<Controller: SwitchIndexController, Searcher: AnyObject & Searchable & IndexNameSettable>(searcher: Searcher,
                                                                                                            interactor: SwitchIndexInteractor,
                                                                                                            controller: Controller) {
    self.init(searcher: searcher,
              interactor: interactor)
    connectController(controller)
  }
  
  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - indexNames: List of names of available indices
     - selectedIndexName: Name of the currently selected index
     - controller: Controller interfacing with a concrete switch index view
   */
  convenience init<Controller: SwitchIndexController, Searcher: AnyObject & Searchable & IndexNameSettable>(searcher: Searcher,
                                                                         indexNames: [IndexName],
                                                                         selectedIndexName: IndexName,
                                                                         controller: Controller) {
    let interactor = SwitchIndexInteractor(indexNames: indexNames,
                                           selectedIndexName: selectedIndexName)
    self.init(searcher: searcher, interactor: interactor)
    connectController(controller)
  }

  
  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller interfacing with a concrete switch index view
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: SwitchIndexController>(_ controller: Controller) -> SwitchIndexInteractor.ControllerConnection<Controller> {
    let connection = interactor.connectController(controller)
    controllerConnections.append(connection)
    return connection
  }
  
}
