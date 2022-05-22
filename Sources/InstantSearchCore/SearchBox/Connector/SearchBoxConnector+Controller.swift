//
//  SearchBoxConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

public extension SearchBoxConnector {

  /**
   - Parameters:
   - searcher: Searcher that handles your searches
   - interactor: Logic that handles new search inputs
   - searchTriggeringMode: Defines the event triggering a new search
   - controller: Controller interfacing with a concrete query input view
   */
  convenience init<Controller: SearchBoxController, Searcher: AnyObject & Searchable & QuerySettable>(searcher: Searcher,
                                                                                                      interactor: SearchBoxInteractor = .init(),
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
  @discardableResult func connectController<Controller: SearchBoxController>(_ controller: Controller) -> SearchBoxInteractor.ControllerConnection<Controller> {
    let connection = interactor.connectController(controller)
    controllerConnections.append(connection)
    return connection
  }

}
