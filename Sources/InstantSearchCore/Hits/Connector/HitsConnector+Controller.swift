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
     - filterState: FilterState that holds your filters
     - controller: Controller interfacing with a concrete hits view
     - externalReload: Defines if controller will be updated automatically by the events or manually
  */
  convenience init<Controller: HitsController>(searcher: HitsSearcher,
                                               interactor: HitsInteractor<Hit>,
                                               filterState: FilterState? = .none,
                                               controller: Controller,
                                               externalReload: Bool = false) where Controller.DataSource == HitsInteractor<Hit> {
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: filterState,
              connectSearcher: { interactor.connectSearcher($0) },
              controller: controller,
              externalReload: externalReload)
  }

  /**
   - Parameters:
     - searcher: Searcher that handles your searches.
     - filterState: FilterState that holds your filters
     - controller: Controller interfacing with a concrete hits view
     - externalReload: Defines if controller will be updated automatically by the events or manually
  */
  convenience init<Controller: HitsController>(searcher: HitsSearcher,
                                               filterState: FilterState? = .none,
                                               controller: Controller,
                                               externalReload: Bool = false) where Controller.DataSource == HitsInteractor<Hit> {
    let interactor = HitsInteractor<Hit>()
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: filterState,
              connectSearcher: { interactor.connectSearcher($0) },
              controller: controller,
              externalReload: externalReload)
  }

  /**
   - Parameters:
     - appID: ID of your application
     - apiKey: Your application API Key. Be sure to use your Search-only API key.
     - indexName: Name of the index to search
     - infiniteScrolling: Whether or not infinite scrolling is enabled
     - showItemsOnEmptyQuery: If false, no results are displayed when the user hasn’t entered any query text
     - filterState: FilterState that holds your filters
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
    let searcher = HitsSearcher(appID: appID,
                                       apiKey: apiKey,
                                       indexName: indexName)
    let interactor = HitsInteractor<Hit>(infiniteScrolling: infiniteScrolling,
                                         showItemsOnEmptyQuery: showItemsOnEmptyQuery)
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: filterState,
              connectSearcher: { interactor.connectSearcher($0) },
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
