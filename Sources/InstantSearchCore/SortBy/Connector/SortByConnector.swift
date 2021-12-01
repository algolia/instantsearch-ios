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
///
/// [Documentation](https://www.algolia.com/doc/api-reference/widgets/sort-by/ios/)
public class SortByConnector {

  /// Searcher that handles your searches
  public let searcher: AnyObject & Searchable & IndexNameSettable

  /// Logic applied to the indices
  public let interactor: SortByInteractor

  /// Connection between interactor and searcher
  public let searcherConnection: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /// List of selectable indices names
  public var indicesNames: [IndexName] {

    get {
      return interactor.items.sorted { item1, item2 in item1.key < item2.key }.map(\.value)
    }

    set {
      let enumeratedIndices = newValue
        .enumerated()
        .map { $0 }
      interactor.items = [Int: IndexName](uniqueKeysWithValues: enumeratedIndices)
    }

  }

  /// Name of currently selected index
  public var selectedIndexName: IndexName? {

    get {
      return interactor.selected.flatMap { interactor.items[$0] }
    }

    set {
      interactor.items
        .first(where: { $0.value == newValue })
        .flatMap { interactor.selected = $0.key }
    }

  }

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: Logic applied to the indices
   */
  public init<Searcher: AnyObject & Searchable & IndexNameSettable>(searcher: Searcher,
                                                                    interactor: SortByInteractor) {
    self.searcher = searcher
    self.interactor = interactor
    self.searcherConnection = interactor.connectSearcher(searcher)
    self.controllerConnections = []
    Telemetry.shared.traceConnector(type: .sortBy)
  }

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - indicesNames: List of the indices names to switch between
     - selected: Consecutive index of the initially selected search index in the list.
   */
  public convenience init<Searcher: AnyObject & Searchable & IndexNameSettable>(searcher: Searcher,
                                                                                indicesNames: [IndexName],
                                                                                selected: Int? = nil) {
    let enumeratedIndices = indicesNames
      .enumerated()
      .map { $0 }
    let items = [Int: IndexName](uniqueKeysWithValues: enumeratedIndices)
    let interactor = SortByInteractor(items: items)
    interactor.selected = selected
    self.init(searcher: searcher,
              interactor: interactor)
    Telemetry.shared.traceConnector(type: .sortBy,
                                    parameters: [
                                      selected == nil ? .none : .selected
                                    ])
  }

}

extension SortByConnector: Connection {

  public func connect() {
    searcherConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    searcherConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}
