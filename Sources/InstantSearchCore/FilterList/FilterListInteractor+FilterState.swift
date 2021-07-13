//
//  FilterListInteractor+FilterState.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public struct FilterListFilterStateConnection<Filter: FilterType & Hashable>: Connection {

  public let interactor: SelectableListInteractor<Filter, Filter>
  public let filterState: FilterState
  public let `operator`: RefinementOperator
  public let groupName: String

  public init(interactor: SelectableListInteractor<Filter, Filter>,
              filterState: FilterState,
              `operator`: RefinementOperator,
              groupName: String = "") {
    self.interactor = interactor
    self.filterState = filterState
    self.operator = `operator`
    self.groupName = groupName
  }

  public func connect() {
    switch `operator` {
    case .or:
      connectFilterState(filterState, to: interactor, via: filterState[or: groupName])
    case .and:
      connectFilterState(filterState, to: interactor, via: SpecializedAndGroupAccessor(filterState[and: groupName]))
    }
  }

  public func disconnect() {
    interactor.onSelectionsComputed.cancelSubscription(for: filterState)
    filterState.onChange.cancelSubscription(for: interactor)
  }

  private func connectFilterState<Interactor: SelectableListInteractor<Filter, Filter>, Accessor: SpecializedGroupAccessor>(_ filterState: FilterState,
                                                                                                                            to interactor: Interactor, via accessor: Accessor) where Accessor.Filter == Filter {
    whenSelectionsComputedThenUpdateFilterState(interactor: interactor, filterState: filterState, via: accessor)
    whenFilterStateChangedThenUpdateSelections(interactor: interactor, filterState: filterState, via: accessor)
  }

  private func whenSelectionsComputedThenUpdateFilterState<Interactor: SelectableListInteractor<Filter, Filter>, Accessor: SpecializedGroupAccessor>(interactor: Interactor,
                                                                                                                                                     filterState: FilterState,

                                                                                                                                                     via accessor: Accessor) where Accessor.Filter == Filter {

    interactor.onSelectionsComputed.subscribePast(with: filterState) { [weak interactor] filterState, filters in

      guard let strongInteractor = interactor else { return }
       switch strongInteractor.selectionMode {
       case .multiple:
         accessor.removeAll()

       case .single:
         accessor.removeAll(strongInteractor.items)
       }

       accessor.addAll(filters)

       filterState.notifyChange()
     }

   }

  private func whenFilterStateChangedThenUpdateSelections<Interactor: SelectableListInteractor<Filter, Filter>, Accessor: SpecializedGroupAccessor>(interactor: Interactor, filterState: FilterState,
                                                                                                                                                    via accessor: Accessor) where Accessor.Filter == Filter {
     filterState.onChange.subscribePast(with: interactor) { interactor, _ in
       interactor.selections = Set(accessor.filters())
     }
   }

}

public extension SelectableListInteractor where Key == Item, Item: FilterType {

  @discardableResult func connectFilterState(_ filterState: FilterState,
                                             operator: RefinementOperator,
                                             groupName: String = "") -> FilterListFilterStateConnection<Key> {
    let connection = FilterListFilterStateConnection(interactor: self, filterState: filterState, operator: `operator`, groupName: groupName)
    connection.connect()
    return connection
  }

}
