//
//  CurrentFiltersInteractor+FilterState.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 19/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension CurrentFiltersInteractor {

  struct FilterStateConnection: Connection {

    public let interactor: CurrentFiltersInteractor
    public let filterState: FilterState
    public let filterGroupIDs: Set<FilterGroup.ID>?

    public init(interactor: CurrentFiltersInteractor,
                filterState: FilterState,
                filterGroupIDs: Set<FilterGroup.ID>? = nil) {
      self.interactor = interactor
      self.filterState = filterState
      self.filterGroupIDs = filterGroupIDs
    }

    public func connect() {

      let filterGroupIDs = self.filterGroupIDs

      filterState.onChange.subscribePast(with: interactor) { [weak filterState] interactor, _ in
        guard let filterState = filterState else { return }
        if let filterGroupIDs = filterGroupIDs {
          interactor.items = filterState.getFiltersAndID().filter { filterGroupIDs.contains($0.id) }
        } else {
          interactor.items = filterState.getFiltersAndID()
        }
      }

      interactor.onItemsComputed.subscribePast(with: filterState) { filterState, items in

        if let filterGroupIDs = filterGroupIDs {
          filterState.filters.removeAll(fromGroupWithIDs: Array(filterGroupIDs))
          items.forEach({ (filterAndID) in
            filterState.filters.add(filterAndID.filter.filter, toGroupWithID: filterAndID.id)
          })
        } else {
          filterState.filters.removeAll()
          items.forEach({ (filterAndID) in
            filterState.filters.add(filterAndID.filter.filter, toGroupWithID: filterAndID.id)
          })
        }

        filterState.notifyChange()
      }

    }

    public func disconnect() {
      filterState.onChange.cancelSubscription(for: interactor)
      interactor.onItemsComputed.cancelSubscription(for: filterState)
    }

  }

}

public extension CurrentFiltersInteractor {
  
  @discardableResult func connectFilterState(_ filterState: FilterState,
                                             filterGroupIDs: Set<FilterGroup.ID>? = nil) -> FilterStateConnection {
    let connection = FilterStateConnection(interactor: self, filterState: filterState, filterGroupIDs: filterGroupIDs)
    connection.connect()
    return connection
  }
  
  @discardableResult func connectFilterState(_ filterState: FilterState,
                                             filterGroupID: FilterGroup.ID?) -> FilterStateConnection {
    if let filterGroupID = filterGroupID {
      return connectFilterState(filterState, filterGroupIDs: Set([filterGroupID]))
    } else {
      return connectFilterState(filterState)
    }
  }
  
  @discardableResult func connectFilterState(_ filterState: FilterState,
                                             filterGroupID: FilterGroup.ID) -> FilterStateConnection {
    return connectFilterState(filterState, filterGroupIDs: Set([filterGroupID]))
  }
  
}
