//
//  FilterMapConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class FilterMapConnector<Filter: FilterType> {

  /// Searcher that handles your searches
  public let searcher: HitsSearcher

  /// FilterState that holds your filters
  public let filterState: FilterState

  /// Logic applied to the filters
  public let interactor: FilterMapInteractor<Filter>

  /// Attribute to filter
  public let attribute: Attribute

  /// Whether we apply an `and` or `or` behavior to the filters in the filter state
  public let `operator`: RefinementOperator

  /// Filter group name
  public let groupName: String

  /// Connection between interactor and searcher
  public let searcherConnection: FilterMapInteractorSearcherConnection<Filter>

  /// Connection between interactor and filterState
  public let filterStateConnection: FilterMapInteractorFilterStateConnection<Filter>

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
  Init with implicit interactor
  - Parameters:
    - searcher: Searcher handling searches for facet values
    - filterState: FilterState that holds your filters
    - items: Map from segment to filter
    - selected: Initially selected segment
    - attribute: Attribute to filter
    - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state
    - groupName: Filter group name
  */
  public init(searcher: HitsSearcher,
              filterState: FilterState,
              items: [Int: Filter],
              selected: Int,
              attribute: Attribute,
              `operator`: RefinementOperator,
              groupName: String? = nil) {
    self.searcher = searcher
    self.filterState = filterState
    self.interactor = .init(items: items)
    self.attribute = attribute
    self.operator = `operator`
    self.groupName = groupName ?? attribute.rawValue
    self.searcherConnection = self.interactor.connectSearcher(searcher,
                                                              attribute: attribute)
    self.filterStateConnection = self.interactor.connectFilterState(filterState,
                                                                    attribute: attribute,
                                                                    operator: `operator`,
                                                                    groupName: groupName)
    self.interactor.selected = selected
    self.controllerConnections = []
    Telemetry.shared.traceConnector(type: .filterMap,
                                    parameters: [
                                      groupName == nil ? .none : .groupName
                                    ])
  }

}

extension FilterMapConnector: Connection {

  public func connect() {
    searcherConnection.connect()
    filterStateConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    searcherConnection.disconnect()
    filterStateConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}

@available(*, deprecated, renamed: "FilterMapConnector")
typealias SelectableFilterConnector = FilterMapConnector
