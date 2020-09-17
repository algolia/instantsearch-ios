//
//  MultiIndexHitsConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

public extension MultiIndexHitsConnector {
  
  /**
   - Parameters:
     - appID: Application ID
     - apiKey: API Key
     - indexModules: List of index modules representing the aggregaged indices
     - controller: Controller interfacing with a concrete multi-index hits view
  */
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
  @discardableResult func connectController<Controller: MultiIndexHitsController>(_ controller: Controller) -> some Connection {
    let connection = interactor.connectController(controller)
    connection.connect()
    return connection
  }
  
}
