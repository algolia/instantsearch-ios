//
//  FilterClearInteractor+FilterState.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 24/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension FilterClearInteractor {

  struct FilterStateConnection: Connection {

    public let filterClearInteractor: FilterClearInteractor
    public let filterState: FilterState
    public let filterGroupIDs: [FilterGroup.ID]?
    public let clearMode: ClearMode

    public init(filterClearInteractor: FilterClearInteractor,
                filterState: FilterState,
                filterGroupIDs: [FilterGroup.ID]? = nil,
                clearMode: ClearMode = .specified) {
      self.filterClearInteractor = filterClearInteractor
      self.filterState = filterState
      self.filterGroupIDs = filterGroupIDs
      self.clearMode = clearMode
    }

    public func connect() {
      let filterGroupIDs = self.filterGroupIDs
      let clearMode = self.clearMode

      filterClearInteractor.onTriggered.subscribe(with: filterState) { filterState, _ in
        defer {
          filterState.notifyChange()
        }

        guard let filterGroupIDs = filterGroupIDs else {
          filterState.filters.removeAll()
          return
        }

        switch clearMode {
        case .specified:
          filterState.filters.removeAll(fromGroupWithIDs: filterGroupIDs)
        case .except:
          filterState.filters.removeAllExcept(filterGroupIDs)
        }

      }

    }

    public func disconnect() {
      filterClearInteractor.onTriggered.cancelSubscription(for: filterState)
    }

  }

}

public extension FilterClearInteractor {

  @discardableResult func connectFilterState(_ filterState: FilterState,
                                             filterGroupIDs: [FilterGroup.ID]? = nil,
                                             clearMode: ClearMode = .specified) -> FilterStateConnection {
    let connection = FilterStateConnection(filterClearInteractor: self, filterState: filterState, filterGroupIDs: filterGroupIDs, clearMode: clearMode)
    connection.connect()
    return connection
  }

}

public enum ClearMode {
  case specified
  case except
}
