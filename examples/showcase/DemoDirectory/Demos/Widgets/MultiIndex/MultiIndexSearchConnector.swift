//
//  MultiIndexSearchConnector.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 23/07/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

struct MultiIndexSearchConnector: Connection {

  let hitsConnector: MultiIndexHitsConnector
  let hitsControllerConnection: Connection

  let queryInputConnector: QueryInputConnector<MultiIndexSearcher>
  let queryInputControllerConnection: Connection
  
  public init<QI: QueryInputController, HC: MultiIndexHitsController>(searcher: MultiIndexSearcher,
                                                                      indexModules: [MultiIndexHitsConnector.IndexModule],
                                                                      hitsController: HC,
                                                                      queryInputInteractor: QueryInputInteractor = .init(),
                                                                      queryInputController: QI) {
    self.hitsConnector = .init(appID: searcher.client.applicationID, apiKey: searcher.client.apiKey, indexModules: indexModules)
    hitsControllerConnection = self.hitsConnector.interactor.connectController(hitsController)
    self.queryInputConnector = .init(searcher: searcher, interactor: queryInputInteractor)
    queryInputControllerConnection = queryInputInteractor.connectController(queryInputController)
    searcher.search()
  }
  
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

  func connect() {
    disconnect()
    hitsConnector.connect()
    hitsControllerConnection.connect()
    queryInputConnector.connect()
    queryInputControllerConnection.connect()
  }

  func disconnect() {
    hitsConnector.disconnect()
    hitsControllerConnection.disconnect()
    queryInputConnector.disconnect()
    queryInputControllerConnection.disconnect()
  }
  
}
