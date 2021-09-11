//
//  MultiIndexSearchConnector.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 23/07/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

/**
Connector encapsulating basic search experience within multiple indices
 
 Managed connections:
 - hits interactor <-> searcher
 - hits interactor <-> hits controller
 - hits interactor <-> filter states (if provided)
 - query input interactor <-> searcher
 - query input interactor <-> query input controller
 - searcher <-> filter states (if provided)
Most of the components associated by this connector are created and connected automatically, it's only required to provide a proper `Controller` implementations.
*/
@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public struct MultiIndexSearchConnector: Connection {

  /// Connector establishing the linkage between searcher, hits interactor and optionally filter state
  public let hitsConnector: MultiIndexHitsConnector

  /// Connection between hits interactor of hits connector and provided hits controller
  public let hitsControllerConnection: Connection

  /// Connector establishing the linkage between searcher and query input interactor
  public let queryInputConnector: QueryInputConnector

  /// Connection between query input interactor of query input connector and provided query input controller
  public let queryInputControllerConnection: Connection

  /**
   - Parameters:
     - searcher: External multi index sercher
     - indexModules: List of index modules associating index name, hits interactor and optional filter state
     - hitsController: Hits controller
     - queryInputInteractor: External query input interactor
     - queryInputController: Query input controller
   */
  public init<QI: QueryInputController, HC: MultiIndexHitsController>(searcher: MultiIndexSearcher,
                                                                      indexModules: [MultiIndexHitsConnector.IndexModule],
                                                                      hitsController: HC,
                                                                      queryInputInteractor: QueryInputInteractor = .init(),
                                                                      queryInputController: QI) {
    let hitsInteractor = MultiIndexHitsInteractor(hitsInteractors: indexModules.map(\.hitsInteractor))
    let filterStates = indexModules.map(\.filterState)
    self.hitsConnector = .init(searcher: searcher, interactor: hitsInteractor, filterStates: filterStates)
    hitsControllerConnection = self.hitsConnector.interactor.connectController(hitsController)
    self.queryInputConnector = .init(searcher: searcher, interactor: queryInputInteractor)
    queryInputControllerConnection = queryInputInteractor.connectController(queryInputController)
    searcher.search()
  }

  /**
   - Parameters:
     - appID: Application ID
     - apiKey: API Key
     - indexModules: List of index modules associating index name, hits interactor and optional filter state
     - hitsController: Hits controller
     - queryInputInteractor: External query input interactor
     - queryInputController: Query input controller
   */
  public init<QI: QueryInputController, HC: MultiIndexHitsController>(appID: ApplicationID,
                                                                      apiKey: APIKey,
                                                                      indexModules: [MultiIndexHitsConnector.IndexModule],
                                                                      hitsController: HC,
                                                                      queryInputInteractor: QueryInputInteractor = .init(),
                                                                      queryInputController: QI) {
    let searcher = MultiIndexSearcher(appID: appID,
                                      apiKey: apiKey,
                                      indexNames: indexModules.map(\.indexName))
    self.init(searcher: searcher,
              indexModules: indexModules,
              hitsController: hitsController,
              queryInputInteractor: queryInputInteractor,
              queryInputController: queryInputController)
  }

  public func connect() {
    disconnect()
    hitsConnector.connect()
    hitsControllerConnection.connect()
    queryInputConnector.connect()
    queryInputControllerConnection.connect()
  }

  public func disconnect() {
    hitsConnector.disconnect()
    hitsControllerConnection.disconnect()
    queryInputConnector.disconnect()
    queryInputControllerConnection.disconnect()
  }

}
