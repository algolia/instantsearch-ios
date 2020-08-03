//
//  SingleIndexSearchConnector.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 23/07/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

public struct SingleIndexSearchConnector<Record: Codable>: Connection {
    
  public let hitsConnector: HitsConnector<Record>
  public let hitsControllerConnection: Connection
  
  public let queryInputConnector: QueryInputConnector<SingleIndexSearcher>
  public let queryInputControllerConnection: Connection
  
  public let filterStateHitsInteractorConnection: Connection?
  public let filterStateSearcherConnection: Connection?
  
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
