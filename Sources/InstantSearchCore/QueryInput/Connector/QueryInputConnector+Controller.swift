//
//  QueryInputConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

extension QueryInputConnector {

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: Logic that handles new search inputs
     - searchTriggeringMode: Defines the event triggering a new search
     - controller: Controller interfacing with a concrete query input view
   */
  public convenience init<Controller: QueryInputController, S: Searcher>(searcher: S,
                                                                         interactor: QueryInputInteractor = .init(),
                                                                         searchTriggeringMode: SearchTriggeringMode = .searchAsYouType,
                                                                         controller: Controller) {
    self.init(searcher: searcher,
              interactor: interactor,
              searchTriggeringMode: searchTriggeringMode)
    connectController(controller)
  }

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller interfacing with a concrete query input view
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: QueryInputController>(_ controller: Controller) -> QueryInputInteractor.ControllerConnection<Controller> {
    let connection = interactor.connectController(controller)
    controllerConnections.append(connection)
    return connection
  }

}
