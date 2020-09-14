//
//  SortByConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient

/// Component that displays a list of indices, allowing a user to change the way hits are sorted
public class SortByConnector {
  
  /// Searcher that handles your searches
  public let searcher: SingleIndexSearcher
  
  /// Logic applied to the indices
  public let interactor: IndexSegmentInteractor
  
  /// Connection between interactor and searcher
  public let searcherConnection: Connection
  
  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]
  
  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: Logic applied to the indices
   */
  public init(searcher: SingleIndexSearcher,
              interactor: IndexSegmentInteractor) {
    self.searcher = searcher
    self.interactor = interactor
    self.searcherConnection = interactor.connectSearcher(searcher: searcher)
    self.controllerConnections = []
  }

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - indicesNames: List of the indices names to switch between
     - selected: Consecutive index of the initially selected search index in the list.
   */
  public convenience init(searcher: SingleIndexSearcher,
                          indicesNames: [IndexName],
                          selected: Int? = nil) {
    let enumeratedIndices = indicesNames
      .map(searcher.client.index(withName:))
      .enumerated()
      .map { $0 }
    let items = [Int: Index](uniqueKeysWithValues: enumeratedIndices)
    let interactor = IndexSegmentInteractor(items: items)
    interactor.selected = selected
    self.init(searcher: searcher, interactor: interactor)
  }

}

public extension SortByConnector {
  
  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - indicesNames: List of the indices names to switch between
     - selected: Consecutive index of the initially selected search index in the list
     - controller: Controller interfacing with a switch index view
     - presenter: Presenter defining how the indices appear in the controller
   */
  convenience init<Controller: SelectableSegmentController>(searcher: SingleIndexSearcher,
                                                            indicesNames: [IndexName],
                                                            selected: Int? = nil,
                                                            controller: Controller,
                                                            presenter: @escaping IndexPresenter = DefaultPresenter.Index.present) where Controller.SegmentKey == Int  {
    let enumeratedIndices = indicesNames
      .map(searcher.client.index(withName:))
      .enumerated()
      .map { $0 }
    let items = [Int: Index](uniqueKeysWithValues: enumeratedIndices)
    let interactor = IndexSegmentInteractor(items: items)
    interactor.selected = selected
    self.init(searcher: searcher, interactor: interactor)
    connectController(controller, presenter: presenter)
  }
  
  /**
   Establishes a connection with the controller using the provided presentation logic
   - Parameters:
     - controller: Controller interfacing with a switch index view
     - presenter: Presenter defining how the indices appear in the controller
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: SelectableSegmentController>(_ controller: Controller,
                                                                                     presenter: @escaping IndexPresenter = DefaultPresenter.Index.present) -> some Connection where Controller.SegmentKey == Int {
    let connection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(connection)
    return connection
  }

  
}

extension SortByConnector: Connection {
  
  public func connect() {
    searcherConnection.connect()
  }

  public func disconnect() {
    searcherConnection.disconnect()
  }
  
}
