//
//  StatsConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

public extension StatsConnector {
  
  /**
    - Parameters:
      - searcher: Searcher that handles your searches
      - interactor: Logic applied to the stats
      - controller: Controller interfacing with a concrete stats view
   */
  convenience init<Controller: StatsTextController>(searcher: SingleIndexSearcher,
                                               interactor: StatsInteractor = .init(),
                                               controller: Controller) {
    self.init(searcher: searcher,
              interactor: interactor)
    connectController(controller)
  }
  
  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller interfacing with a concrete stats view
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: StatsTextController>(_ controller: Controller) -> some Connection {
    let connection = interactor.connectController(controller)
    controllerConnections.append(connection)
    return connection
  }
  
}
