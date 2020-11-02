//
//  SingleIndexSearchConnector.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 23/07/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

/**
 Connector encapsulating basic search experience within single index
 
 Managed connections:
 - hits interactor <-> searcher
 - hits interactor <-> hits controller
 - hits interactor <-> filter state (if provided)
 - query input interactor <-> searcher
 - query input interactor <-> query input controller
 - searcher <-> filter state (if provided)
 
 Most of the components associated by this connector are created and connected automatically, it's only required to provide a proper `Controller` implementations.
 */
public struct SingleIndexSearchConnector<Record: Codable>: Connection {

  /// Connector establishing the linkage between searcher, hits interactor and optionally filter state
  public let hitsConnector: HitsConnector<Record>

  /// Connection between hits interactor of hits connector and provided hits controller
  public let hitsControllerConnection: Connection

  /// Connector establishing the linkage between searcher and query input interactor
  public let queryInputConnector: QueryInputConnector

  /// Connection between query input interactor of query input connector and provided query input controller
  public let queryInputControllerConnection: Connection

  /// Connection between filter state and hits interactor of hits connector
  public let filterStateHitsInteractorConnection: Connection?

  /// Connection between filter state and searcher
  public let filterStateSearcherConnection: Connection?

  /**
   - Parameters:
     - searcher: External single index sercher
     - queryInputInteractor: External query input interactor
     - queryInputController: Query input controller
     - hitsInteractor: External hits interactor
     - hitsController: Hits controller
     - filterState: Filter state
  */
  public init<HC: HitsController, QI: QueryInputController>(searcher: SingleIndexSearcher,
                                                            queryInputInteractor: QueryInputInteractor = .init(),
                                                            queryInputController: QI,
                                                            hitsInteractor: HitsInteractor<Record> = .init(),
                                                            hitsController: HC,
                                                            filterState: FilterState? = nil) where HC.DataSource == HitsInteractor<Record> {
    hitsConnector = .init(searcher: searcher, interactor: hitsInteractor, filterState: filterState)
    queryInputConnector = .init(searcher: searcher, interactor: queryInputInteractor)

    queryInputControllerConnection = queryInputInteractor.connectController(queryInputController)
    hitsControllerConnection = hitsInteractor.connectController(hitsController)

    if let filterState = filterState {
      filterStateHitsInteractorConnection = hitsInteractor.connectFilterState(filterState)
      filterStateSearcherConnection = searcher.connectFilterState(filterState)
    } else {
      filterStateHitsInteractorConnection = nil
      filterStateSearcherConnection = nil
    }

  }

  /**
   - Parameters:
     - appID: Application ID
     - apiKey: API Key
     - indexName: Name of the index in which search will be performed
     - queryInputInteractor: External query input interactor
     - queryInputController: Query input controller
     - hitsInteractor: External hits interactor
     - hitsController: Hits controller
     - filterState: Filter state
   */
  public init<HC: HitsController, QI: QueryInputController>(appID: ApplicationID,
                                                            apiKey: APIKey,
                                                            indexName: IndexName,
                                                            queryInputInteractor: QueryInputInteractor = .init(),
                                                            queryInputController: QI,
                                                            hitsInteractor: HitsInteractor<Record> = .init(),
                                                            hitsController: HC,
                                                            filterState: FilterState? = nil)  where HC.DataSource == HitsInteractor<Record> {
    let searcher = SingleIndexSearcher(appID: appID,
                                       apiKey: apiKey,
                                       indexName: indexName)
    self.init(searcher: searcher,
              queryInputInteractor: queryInputInteractor,
              queryInputController: queryInputController,
              hitsInteractor: hitsInteractor,
              hitsController: hitsController,
              filterState: filterState)
  }

  public func connect() {
    disconnect()
    queryInputConnector.connect()
    queryInputControllerConnection.connect()
    hitsConnector.connect()
    hitsControllerConnection.connect()
    filterStateSearcherConnection?.connect()
    filterStateHitsInteractorConnection?.connect()
  }

  public func disconnect() {
    queryInputConnector.disconnect()
    queryInputControllerConnection.disconnect()
    hitsConnector.disconnect()
    hitsControllerConnection.disconnect()
    filterStateSearcherConnection?.disconnect()
    filterStateHitsInteractorConnection?.disconnect()
  }

}
