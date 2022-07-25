//
//  HierarchicalInteractor+FilterState.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 03/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension HierarchicalInteractor {

  struct FilterStateConnection: Connection {

    public let interactor: HierarchicalInteractor
    public let filterState: FilterState

    public func connect() {

      let groupName = "_hierarchical"

      filterState[hierarchical: groupName].set(interactor.hierarchicalAttributes)

      interactor.onSelectionsComputed.subscribePast(with: filterState) { [weak interactor] filterState, hierarchicalPath in

        interactor?.selections = hierarchicalPath.map { $0.value.description }

        filterState[hierarchical: groupName].removeAll()

        if let lastSelectedFilter = hierarchicalPath.last {
          filterState[hierarchical: groupName].add(lastSelectedFilter)
          filterState[hierarchical: groupName].set(hierarchicalPath)
        } else {
          let emptyFiltersList: [Filter.Facet] = []
          filterState[hierarchical: groupName].set(emptyFiltersList)
        }

        filterState.notifyChange()

      }

      filterState.onChange.subscribePast(with: interactor) { _, _ in
        // TODO
      }

    }

    public func disconnect() {
      interactor.onSelectionsChanged.cancelSubscription(for: filterState)
      filterState.onChange.cancelSubscription(for: interactor)
    }

  }

}

public extension HierarchicalInteractor {

  @discardableResult func connectFilterState(_ filterState: FilterState) -> FilterStateConnection {
    let connection = FilterStateConnection(interactor: self, filterState: filterState)
    connection.connect()
    return connection
  }

}
