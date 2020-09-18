//
//  HitsConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

public extension HitsConnector {
  
  /**
   - Parameters:
     - searcher: Searcher that handles your searches.
     - interactor: External hits interactor
     - filterState: Filter state holding your filters
     - controller: Controller interfacing with a concrete hits view
     - externalReload: Defines if controller will be updated automatically by the events or manually
  */
  convenience init<Controller: HitsController>(searcher: SingleIndexSearcher,
                   interactor: HitsInteractor<Hit> = .init(),
                   filterState: FilterState? = .none,
                   controller: Controller,
                   externalReload: Bool = false) where Controller.DataSource == HitsInteractor<Hit> {
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: filterState,
              connectSearcher: interactor.connectSearcher,
              controller: controller,
              externalReload: externalReload)
  }
  
  /**
   - Parameters:
     - appID: Application ID
     - apiKey: API Key
     - indexName: Name of the index in which search will be performed
     - infiniteScrolling: Infinite scrolling toggle
     - showItemsOnEmptyQuery: Defines if interactor gives access to  the hits in case of empty query
     - filterState: Filter state holding your filters
     - controller: Controller interfacing with a concrete hits view
     - externalReload: Defines if controller will be updated automatically by the events or manually
  */
  convenience init<Controller: HitsController>(appID: ApplicationID,
                                               apiKey: APIKey,
                                               indexName: IndexName,
                                               infiniteScrolling: InfiniteScrolling = Constants.Defaults.infiniteScrolling,
                                               showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery,
                                               filterState: FilterState? = .none,
                                               controller: Controller,
                                               externalReload: Bool = false) where Controller.DataSource == HitsInteractor<Hit> {
    let searcher = SingleIndexSearcher(appID: appID,
                                       apiKey: apiKey,
                                       indexName: indexName)
    let interactor = HitsInteractor<Hit>(infiniteScrolling: infiniteScrolling, showItemsOnEmptyQuery: showItemsOnEmptyQuery)
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: filterState,
              connectSearcher: interactor.connectSearcher,
              controller: controller,
              externalReload: externalReload)
  }

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller interfacing with a concrete hits view
     - externalReload: Defines if controller will be updated automatically by the events or manually
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: HitsController>(_ controller: Controller,
                                                                        externalReload: Bool = false) -> HitsInteractor<Hit>.ControllerConnection<Controller> where Controller.DataSource == HitsInteractor<Hit> {
    let connection = interactor.connectController(controller, externalReload: externalReload)
    controllerConnections.append(connection)
    return connection
  }

}
