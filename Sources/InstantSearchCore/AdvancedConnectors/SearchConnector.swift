//
//  SearchConnector.swift
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
public struct SearchConnector<Record: Codable>: Connection {

  /// Connector establishing the linkage between searcher, hits interactor and optionally filter state
  public let hitsConnector: HitsConnector<Record>

  /// Connection between hits interactor of hits connector and provided hits controller
  public let hitsControllerConnection: Connection

  /// Connector establishing the linkage between searcher and search box interactor
  public let searchBoxConnector: SearchBoxConnector

  /// Connection between query input interactor of search box connector and provided search box controller
  public let searchBoxControllerConnection: Connection

  /// Connection between filter state and hits interactor of hits connector
  public let filterStateHitsInteractorConnection: Connection?

  /// Connection between filter state and searcher
  public let filterStateSearcherConnection: Connection?

  /**
   - Parameters:
   - searcher: External single index sercher
   - searchBOxInteractor: External search box interactor
   - searchBoxController: Search box controller
   - hitsInteractor: External hits interactor
   - hitsController: Hits controller
   - filterState: Filter state
   */
  public init<HC: HitsController, SBC: SearchBoxController>(searcher: HitsSearcher,
                                                            searchBoxInteractor: SearchBoxInteractor = .init(),
                                                            searchBoxController: SBC,
                                                            hitsInteractor: HitsInteractor<Record>,
                                                            hitsController: HC,
                                                            filterState: FilterState? = nil) where HC.DataSource == HitsInteractor<Record> {
    hitsConnector = .init(searcher: searcher, interactor: hitsInteractor, filterState: filterState)
    searchBoxConnector = .init(searcher: searcher, interactor: searchBoxInteractor)

    searchBoxControllerConnection = searchBoxInteractor.connectController(searchBoxController)
    hitsControllerConnection = hitsInteractor.connectController(hitsController)

    if let filterState = filterState {
      filterStateHitsInteractorConnection = hitsInteractor.connectFilterState(filterState)
      filterStateSearcherConnection = searcher.connectFilterState(filterState)
    } else {
      filterStateHitsInteractorConnection = nil
      filterStateSearcherConnection = nil
    }

    Telemetry.shared.traceConnector(type: .hitsSearcher,
                                    parameters: [
                                      filterState == nil ? .none : .filterState
                                    ])
  }

  /**
   - Parameters:
   - appID: Application ID
   - apiKey: API Key
   - indexName: Name of the index in which search will be performed
   - searchBoxInteractor: External search box interactor
   - searchBoxController: Search box controller
   - hitsInteractor: External hits interactor
   - hitsController: Hits controller
   - filterState: Filter state
   */
  public init<HC: HitsController, SBC: SearchBoxController>(appID: ApplicationID,
                                                            apiKey: APIKey,
                                                            indexName: IndexName,
                                                            searchBoxInteractor: SearchBoxInteractor = .init(),
                                                            searchBoxController: SBC,
                                                            hitsInteractor: HitsInteractor<Record>,
                                                            hitsController: HC,
                                                            filterState: FilterState? = nil)  where HC.DataSource == HitsInteractor<Record> {
    let searcher = HitsSearcher(appID: appID,
                                apiKey: apiKey,
                                indexName: indexName)
    self.init(searcher: searcher,
              searchBoxInteractor: searchBoxInteractor,
              searchBoxController: searchBoxController,
              hitsInteractor: hitsInteractor,
              hitsController: hitsController,
              filterState: filterState)

    Telemetry.shared.traceConnector(type: .hitsSearcher,
                                    parameters: [
                                      .appID,
                                      .apiKey,
                                      .indexName,
                                      filterState == nil ? .none : .filterStateParameter
                                    ])
  }

  public func connect() {
    disconnect()
    searchBoxConnector.connect()
    searchBoxControllerConnection.connect()
    hitsConnector.connect()
    hitsControllerConnection.connect()
    filterStateSearcherConnection?.connect()
    filterStateHitsInteractorConnection?.connect()
  }

  public func disconnect() {
    searchBoxConnector.disconnect()
    searchBoxControllerConnection.disconnect()
    hitsConnector.disconnect()
    hitsControllerConnection.disconnect()
    filterStateSearcherConnection?.disconnect()
    filterStateHitsInteractorConnection?.disconnect()
  }

}

@available(*, deprecated, renamed: "SearchConnector")
public typealias SingleIndexSearchConnector = SearchConnector

public extension SearchConnector {

  /// Connector establishing the linkage between searcher and query input interactor
  @available(*, deprecated, renamed: "searchBoxConnector")
  var queryInputConnector: QueryInputConnector {
    searchBoxConnector
  }

  /// Connection between query input interactor of query input connector and provided query input controller
  @available(*, deprecated, renamed: "searchBoxControllerConnection")
  var queryInputControllerConnection: Connection {
    searchBoxControllerConnection
  }

  /**
   - Parameters:
   - searcher: External single index sercher
   - queryInputInteractor: External query input interactor
   - queryInputController: Query input controller
   - hitsInteractor: External hits interactor
   - hitsController: Hits controller
   - filterState: Filter state
   */
  @available(*, deprecated, renamed: "init(searcher:searchBoxInteractor:searchBoxController:hitsInteractor:hitsController:filterState:)")
  init<HC: HitsController, QIC: QueryInputController>(searcher: HitsSearcher,
                                                      queryInputInteractor: QueryInputInteractor = .init(),
                                                      queryInputController: QIC,
                                                      hitsInteractor: HitsInteractor<Record>,
                                                      hitsController: HC,
                                                      filterState: FilterState? = nil) where HC.DataSource == HitsInteractor<Record> {
    self.init(searcher: searcher,
              searchBoxInteractor: queryInputInteractor,
              searchBoxController: queryInputController,
              hitsInteractor: hitsInteractor,
              hitsController: hitsController,
              filterState: filterState)
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
  @available(*, deprecated, renamed: "init(appID:apiKey:indexName:searchBoxInteractor:searchBoxController:hitsInteractor:hitsController:filterState:)")
  init<HC: HitsController, SBC: SearchBoxController>(appID: ApplicationID,
                                                     apiKey: APIKey,
                                                     indexName: IndexName,
                                                     queryInputInteractor: SearchBoxInteractor = .init(),
                                                     queryInputController: SBC,
                                                     hitsInteractor: HitsInteractor<Record>,
                                                     hitsController: HC,
                                                     filterState: FilterState? = nil)  where HC.DataSource == HitsInteractor<Record> {
    self.init(appID: appID,
              apiKey: apiKey,
              indexName: indexName,
              searchBoxInteractor: queryInputInteractor,
              searchBoxController: queryInputController,
              hitsInteractor: hitsInteractor,
              hitsController: hitsController,
              filterState: filterState)
  }

}
