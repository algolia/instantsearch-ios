//
//  SingleIndexSearchConnector.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 23/07/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

struct SingleIndexSearchConnector<Record: Codable>: Connection {
  
  typealias HitsInteractor = InstantSearch.HitsInteractor<Record>
  
  let hitsConnector: HitsConnector<Record>
  let hitsControllerConnection: Connection

  let queryInputConnector: QueryInputConnector<SingleIndexSearcher>
  let queryInputControllerConnection: Connection
  
  let filterStateHitsInteractorConnection: Connection?
  let filterStateSearcherConnection: Connection?
    
  init<HC: HitsController, QI: QueryInputController>(searcher: SingleIndexSearcher,
       queryInputInteractor: QueryInputInteractor = .init(),
       queryInputController: QI,
       hitsInteractor: HitsInteractor = .init(),
       hitsController: HC,
       filterState: FilterState? = nil) where HC.DataSource == HitsInteractor {
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
  
  init<HC: HitsController, QI: QueryInputController>(appID: ApplicationID,
       apiKey: APIKey,
       indexName: IndexName,
       queryInputInteractor: QueryInputInteractor = .init(),
       queryInputController: QI,
       hitsInteractor: HitsInteractor = .init(),
       hitsController: HC,
       filterState: FilterState? = nil)  where HC.DataSource == HitsInteractor {
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
  
  init<HC: HitsController>(searcher: SingleIndexSearcher,
                           searchController: UISearchController,
                           hitsInteractor: HitsInteractor = .init(),
                           hitsController: HC,
                           filterState: FilterState? = nil)  where HC.DataSource == HitsInteractor {
    let queryInputInteractor = QueryInputInteractor()
    let textFieldController = TextFieldController(searchBar: searchController.searchBar)
    self.init(searcher: searcher,
              queryInputInteractor: queryInputInteractor,
              queryInputController: textFieldController,
              hitsInteractor: hitsInteractor,
              hitsController: hitsController,
              filterState: filterState)
  }

  
  init<HC: HitsController>(appID: ApplicationID,
                           apiKey: APIKey,
                           indexName: IndexName,
                           searchController: UISearchController,
                           hitsInteractor: HitsInteractor = .init(),
                           hitsController: HC,
                           filterState: FilterState? = nil)  where HC.DataSource == HitsInteractor {
    let searcher = SingleIndexSearcher(appID: appID,
                                       apiKey: apiKey,
                                       indexName: indexName)
    let queryInputInteractor = QueryInputInteractor()
    let textFieldController = TextFieldController(searchBar: searchController.searchBar)
    self.init(searcher: searcher,
              queryInputInteractor: queryInputInteractor,
              queryInputController: textFieldController,
              hitsInteractor: hitsInteractor,
              hitsController: hitsController,
              filterState: filterState)
  }

  func connect() {
    disconnect()
    queryInputConnector.connect()
    queryInputControllerConnection.connect()
    hitsConnector.connect()
    hitsControllerConnection.connect()
    filterStateSearcherConnection?.connect()
    filterStateHitsInteractorConnection?.connect()
  }
  
  func disconnect() {
    queryInputConnector.disconnect()
    queryInputControllerConnection.disconnect()
    hitsConnector.disconnect()
    hitsControllerConnection.disconnect()
    filterStateSearcherConnection?.disconnect()
    filterStateHitsInteractorConnection?.disconnect()
  }
    
}
