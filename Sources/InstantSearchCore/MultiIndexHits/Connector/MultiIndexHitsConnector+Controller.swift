//
//  MultiIndexHitsConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public extension MultiIndexHitsConnector {

  /**
   - Parameters:
     - appID: ID of your application
     - apiKey: Your application API Key
     - indexModules: List of components representing the single index, containing its name, hits interactor and an optional filter state
     - controller: Controller interfacing with a concrete multi-index hits view
  */
  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  convenience init<Controller: MultiIndexHitsController>(appID: ApplicationID,
                                                         apiKey: APIKey,
                                                         indexModules: [IndexModule],
                                                         controller: Controller) {
    let searcher = MultiIndexSearcher(appID: appID,
                                      apiKey: apiKey,
                                      indexNames: indexModules.map { $0.indexName })
    let interactor = MultiIndexHitsInteractor(hitsInteractors: indexModules.map { $0.hitsInteractor })
    self.init(searcher: searcher,
              interactor: interactor,
              filterStates: indexModules.map { $0.filterState })
    connectController(controller)
  }

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller interfacing with a concrete multi-index hits view
   - Returns: Established connection
  */
  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  @discardableResult func connectController<Controller: MultiIndexHitsController>(_ controller: Controller) -> MultiIndexHitsInteractor.ControllerConnection<Controller> {
    let connection = interactor.connectController(controller)
    connection.connect()
    return connection
  }

}
