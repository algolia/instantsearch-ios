//
//  NumberRangeInteractor+FilterState.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 14/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension NumberRange {

  struct FilterStateConnection<Number: Comparable & DoubleRepresentable>: Connection {

    public let interactor: NumberRangeInteractor<Number>
    public let filterState: FilterState
    public let attribute: Attribute
    public let `operator`: RefinementOperator
    public let groupName: String?

    public init(interactor: NumberRangeInteractor<Number>,
                filterState: FilterState,
                attribute: Attribute,
                `operator`: RefinementOperator = .and,
                groupName: String? = nil) {
      self.interactor = interactor
      self.filterState = filterState
      self.attribute = attribute
      self.operator = `operator`
      self.groupName = groupName
    }

    public func connect() {

      let groupName = self.groupName ?? attribute.rawValue

      switch `operator` {
      case .and:
        connect(interactor, with: filterState, attribute: attribute, via: SpecializedAndGroupAccessor(filterState[and: groupName]))
      case .or:
        connect(interactor, with: filterState, attribute: attribute, via: filterState[or: groupName])
      }
    }

    public func disconnect() {
      filterState.onChange.cancelSubscription(for: interactor)
      interactor.onNumberRangeComputed.cancelSubscription(for: filterState)
    }

    private func connect<Accessor: SpecializedGroupAccessor>(_ interactor: NumberRangeInteractor<Number>,
                                                             with: FilterState,
                                                             attribute: Attribute,
                                                             via accessor: Accessor) where Accessor.Filter == Filter.Numeric {
      whenFilterStateChangedUpdateRange(interactor: interactor, filterState: with, attribute: attribute, accessor: accessor)
      whenRangeComputedUpdateFilterState(interactor: interactor, filterState: with, attribute: attribute, accessor: accessor)
    }

    private func whenFilterStateChangedUpdateRange<Accessor: SpecializedGroupAccessor>(interactor: NumberRangeInteractor<Number>,
                                                                                       filterState: FilterState,
                                                                                       attribute: Attribute,
                                                                                       accessor: Accessor) where Accessor.Filter == Filter.Numeric {

      func extractRange(from numericFilter: Filter.Numeric) -> ClosedRange<Number>? {
        switch numericFilter.value {
        case .range(let closedRange):
          return Number(closedRange.lowerBound)...Number(closedRange.upperBound)
        case .comparison:
          return nil
        }
      }

      filterState.onChange.subscribePast(with: interactor) { interactor, _ in
        interactor.item = accessor.filters(for: attribute).compactMap(extractRange).first
      }

    }

    private func whenRangeComputedUpdateFilterState<Accessor: SpecializedGroupAccessor>(interactor: NumberRangeInteractor<Number>,
                                                                                        filterState: FilterState,
                                                                                        attribute: Attribute,
                                                                                        accessor: Accessor) where Accessor.Filter == Filter.Numeric {

      func numericFilter(with range: ClosedRange<Number>) -> Filter.Numeric {
        let castedRange: ClosedRange<Double> = range.lowerBound.toDouble()...range.upperBound.toDouble()
        return .init(attribute: attribute, range: castedRange)
      }

      let removeCurrentItem = { [weak interactor] in
        guard let item = interactor?.item else { return }
        accessor.remove(numericFilter(with: item))
      }

      let addItem: (ClosedRange<Number>?) -> Void = { range in
        guard let range = range else { return }
        accessor.add(numericFilter(with: range))
      }

      interactor.onNumberRangeComputed.subscribePast(with: filterState) { filterState, computedRange in
        removeCurrentItem()
        addItem(computedRange)
        filterState.notifyChange()
      }

    }

  }

}

public extension NumberRangeInteractor {

  @discardableResult func connectFilterState(_ filterState: FilterState,
                                             attribute: Attribute,
                                             operator: RefinementOperator = .and,
                                             groupName: String? = nil) -> NumberRange.FilterStateConnection<Number> {
    let connection = NumberRange.FilterStateConnection<Number>(interactor: self,
                                                               filterState: filterState,
                                                               attribute: attribute,
                                                               operator: `operator`,
                                                               groupName: groupName)
    connection.connect()
    return connection
  }

}
