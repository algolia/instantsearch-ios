//
//  SelectableFilterConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class SelectableFilterConnector<Filter: FilterType>: Connection {

  public let searcher: SingleIndexSearcher
  public let filterState: FilterState
  public let interactor: SelectableSegmentInteractor<Int, Filter>
  public let attribute: Attribute
  public let `operator`: RefinementOperator
  public let groupName: String

  public let searcherConnection: SelectableFilterInteractorSearcherConnection<Filter>
  public let filterStateConnection: SelectableFilterInteractorFilterStateConnection<Filter>

  public init(searcher: SingleIndexSearcher,
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
  }

  public func connect() {
    searcherConnection.connect()
    filterStateConnection.connect()
  }

  public func disconnect() {
    searcherConnection.disconnect()
    filterStateConnection.disconnect()
  }

}
