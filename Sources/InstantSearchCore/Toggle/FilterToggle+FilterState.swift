//
//  SelectableInteractor+Filter+FilterState.swift
//  InstantSearchCore-iOS
//
//  Created by Vladislav Fitc on 06/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public enum FilterToggle {}

public extension FilterToggle {

  struct FilterStateConnection<Filter: FilterType>: Connection {

    public let interactor: SelectableInteractor<Filter>
    public let filterState: FilterState
    public let `operator`: RefinementOperator
    public let groupName: String

    public init(interactor: SelectableInteractor<Filter>,
                filterState: FilterState,
                operator: RefinementOperator,
                groupName: String? = nil) {
      self.interactor = interactor
      self.filterState = filterState
      self.operator = `operator`
      self.groupName = groupName ?? interactor.item.attribute.rawValue
    }

    public func connect() {
      switch `operator` {
      case .and:
        connectFilterState(via: SpecializedAndGroupAccessor(filterState[and: groupName]))
      case .or:
        connectFilterState(via: filterState[or: groupName])
      }
    }

    public func disconnect() {
      filterState.onChange.cancelSubscription(for: interactor)
      interactor.onSelectedComputed.cancelSubscription(for: filterState)
    }

    private func connectFilterState<GroupAccessor: SpecializedGroupAccessor>(via accessor: GroupAccessor) where GroupAccessor.Filter == Filter {
      whenFilterStateChangedThenUpdateSelections(via: accessor)
      whenSelectionsComputedThenUpdateFilterState(attribute: interactor.item.attribute, via: accessor)
    }

    func whenFilterStateChangedThenUpdateSelections<GroupAccessor: SpecializedGroupAccessor>(via accessor: GroupAccessor) where GroupAccessor.Filter == Filter {

      let onChange: (SelectableInteractor, ReadOnlyFiltersContainer) -> Void = {  interactor, _ in
        interactor.isSelected = accessor.contains(interactor.item)
      }

      onChange(interactor, ReadOnlyFiltersContainer(filterState: filterState))

      filterState.onChange.subscribePast(with: interactor, callback: onChange)
    }

    func whenSelectionsComputedThenUpdateFilterState<GroupAccessor: SpecializedGroupAccessor>(attribute: Attribute,
                                                                                              via accessor: GroupAccessor) where GroupAccessor.Filter == Filter {

      interactor.onSelectedComputed.subscribePast(with: filterState) { [weak interactor] filterState, computedSelected in

        guard
          let interactor = interactor
          else { return }

        if computedSelected {
          accessor.add(interactor.item)
        } else {
          accessor.remove(interactor.item)
        }

        filterState.notifyChange()

      }

    }

    func whenSelectionsComputedThenUpdateFilterState<F: FilterType>(attribute: Attribute,
                                                                    groupID: FilterGroup.ID,
                                                                    default: F) {

      interactor.onSelectedComputed.subscribePast(with: filterState) { [weak interactor] filterState, computedSelected in

        guard let interactor = interactor else { return }

        if computedSelected {
          filterState.filters.remove(`default`, fromGroupWithID: groupID)
          filterState.filters.add(interactor.item, toGroupWithID: groupID)
        } else {
          filterState.filters.remove(interactor.item, fromGroupWithID: groupID)
          filterState.filters.add(`default`, toGroupWithID: groupID)
        }

        filterState.notifyChange()

      }

    }

  }

}

public extension SelectableInteractor where Item: FilterType {

  @discardableResult func connectFilterState(_ filterState: FilterState,

                                             operator: RefinementOperator = .or,

                                             groupName: String? = nil) -> FilterToggle.FilterStateConnection<Item> {
    let connection = FilterToggle.FilterStateConnection(interactor: self, filterState: filterState, operator: `operator`, groupName: groupName)
    connection.connect()
    return connection
  }

}
