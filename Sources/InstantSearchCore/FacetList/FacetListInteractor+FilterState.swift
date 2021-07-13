//
//  FacetListInteractor+FilterState.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension FacetListConnector {

  struct FilterStateConnection: Connection {

    public let interactor: FacetListInteractor
    public let filterState: FilterState
    public let attribute: Attribute
    public let `operator`: RefinementOperator
    public let groupName: String?

    public func connect() {
      let groupName = self.groupName ?? attribute.rawValue
      let groupID: FilterGroup.ID
      switch `operator` {
      case .and:
        groupID = .and(name: groupName)
      case .or:
        groupID = .or(name: groupName, filterType: .facet)
      }
      connect(filterState, to: interactor, with: attribute, via: groupID)
    }

    public func disconnect() {
      interactor.onSelectionsComputed.cancelSubscription(for: filterState)
      filterState.onChange.cancelSubscription(for: interactor)
    }

    private func connect(_ filterState: FilterState,
                         to interactor: FacetListInteractor,
                         with attribute: Attribute,
                         via groupID: FilterGroup.ID) {
      whenSelectionsComputedThenUpdateFilterState(interactor: interactor, filterState: filterState, attribute: attribute, via: groupID)
      whenFilterStateChangedThenUpdateSelections(interactor: interactor, filterState: filterState, via: groupID)
    }

    private func whenSelectionsComputedThenUpdateFilterState(interactor: FacetListInteractor,
                                                             filterState: FilterState,
                                                             attribute: Attribute,
                                                             via groupID: FilterGroup.ID) {
      interactor.onSelectionsComputed.subscribePast(with: filterState) { filterState, selections in
        let filters = selections.map { Filter.Facet(attribute: attribute, stringValue: $0) }
        filterState.removeAll(fromGroupWithID: groupID)
        filterState.addAll(filters: filters, toGroupWithID: groupID)
        filterState.notifyChange()
      }

    }

    private func whenFilterStateChangedThenUpdateSelections(interactor: FacetListInteractor,
                                                            filterState: FilterState,
                                                            via groupID: FilterGroup.ID) {

      func extractString(from filter: Filter.Facet) -> String? {
        if case .string(let stringValue) = filter.value {
          return stringValue
        } else {
          return nil
        }
      }

      filterState.onChange.subscribePast(with: interactor) { interactor, filterState in
        let filters: [Filter.Facet]
        switch groupID {
        case .and(name: let groupName):
          filters = filterState[and: groupName].filters()
        case .or(name: let groupName, _):
          filters = filterState[or: groupName].filters()
        case .hierarchical:
          return
        }
        interactor.selections = Set(filters.compactMap(extractString))
      }
    }

  }

}

public extension FacetListInteractor {

  @discardableResult func connectFilterState(_ filterState: FilterState,
                                             with attribute: Attribute,
                                             operator: RefinementOperator,
                                             groupName: String? = nil) -> FacetListConnector.FilterStateConnection {
    let connection = FacetListConnector.FilterStateConnection(interactor: self, filterState: filterState, attribute: attribute, operator: `operator`, groupName: groupName)
    connection.connect()
    return connection
  }

}
