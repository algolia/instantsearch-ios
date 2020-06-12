//
//  FacetListInteractor+FilterState.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public enum FacetList {

  public struct FilterStateConnection: Connection {

    public let interactor: FacetListInteractor
    public let filterState: FilterState
    public let attribute: Attribute
    public let `operator`: RefinementOperator
    public let groupName: String?

    public func connect() {
      let groupName = self.groupName ?? attribute.rawValue

      switch `operator` {
      case .and:
        connect(filterState, to: interactor, with: attribute, via: SpecializedAndGroupAccessor(filterState[and: groupName]))

      case .or:
        connect(filterState, to: interactor, with: attribute, via: filterState[or: groupName])
      }
    }

    public func disconnect() {
      interactor.onSelectionsComputed.cancelSubscription(for: filterState)
      filterState.onChange.cancelSubscription(for: interactor)
    }

    private func connect<Accessor: SpecializedGroupAccessor>(_ filterState: FilterState,
                                                             to interactor: FacetListInteractor,
                                                             with attribute: Attribute,
                                                             via accessor: Accessor) where Accessor.Filter == Filter.Facet {
      whenSelectionsComputedThenUpdateFilterState(interactor: interactor, filterState: filterState, attribute: attribute, via: accessor)
      whenFilterStateChangedThenUpdateSelections(interactor: interactor, filterState: filterState, via: accessor)
    }

    private func whenSelectionsComputedThenUpdateFilterState<Accessor: SpecializedGroupAccessor>(interactor: FacetListInteractor,
                                                                                                 filterState: FilterState,
                                                                                                 attribute: Attribute,
                                                                                                 via accessor: Accessor) where Accessor.Filter == Filter.Facet {
      interactor.onSelectionsComputed.subscribePast(with: filterState) { filterState, selections in
        let filters = selections.map { Filter.Facet(attribute: attribute, stringValue: $0) }
        accessor.removeAll()
        accessor.addAll(filters)
        filterState.notifyChange()
      }

    }

    private func whenFilterStateChangedThenUpdateSelections<Accessor: SpecializedGroupAccessor>(interactor: FacetListInteractor,
                                                                                                filterState: FilterState,
                                                                                                via accessor: Accessor) where Accessor.Filter == Filter.Facet {

      func extractString(from filter: Filter.Facet) -> String? {
        if case .string(let stringValue) = filter.value {
          return stringValue
        } else {
          return nil
        }
      }

      filterState.onChange.subscribePast(with: interactor) { interactor, _ in
        interactor.selections = Set(accessor.filters().compactMap(extractString))
      }
    }

  }

}

public extension FacetListInteractor {

  @discardableResult func connectFilterState(_ filterState: FilterState,
                                             with attribute: Attribute,
                                             operator: RefinementOperator,
                                             groupName: String? = nil) -> FacetList.FilterStateConnection {
    let connection = FacetList.FilterStateConnection(interactor: self, filterState: filterState, attribute: attribute, operator: `operator`, groupName: groupName)
    connection.connect()
    return connection
  }

}
