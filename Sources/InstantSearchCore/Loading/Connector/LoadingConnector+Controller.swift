//
//  LoadingConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

public extension LoadingConnector {

  /**
    - Parameters:
      - searcher: Searcher that handles your searches
      - interactor: Logic applied to a loading indicator
      - controller: Controller that interfaces with a concrete loading view
   */
  convenience init<Controller: LoadingController>(searcher: Searcher,
                                                  interactor: LoadingInteractor = .init(),
                                                  controller: Controller) {
    self.init(searcher: searcher, interactor: interactor)
    connectController(controller)
  }

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller that interfaces with a concrete loading view
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: LoadingController>(_ controller: Controller) -> LoadingInteractor.ControllerConnection<Controller, Bool> {
    let connection = interactor.connectController(controller)
    controllerConnections.append(connection)
    return connection
  }

}
