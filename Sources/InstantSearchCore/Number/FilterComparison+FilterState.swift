//
//  FilterComparisonConnectFilterState.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 04/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension NumberInteractor {

  struct FilterStateConnection: Connection {

    public let interactor: NumberInteractor
    public let filterState: FilterState
    public let attribute: Attribute
    public let numericOperator: Filter.Numeric.Operator
    public let `operator`: RefinementOperator
    public let groupName: String?

    public init(interactor: NumberInteractor,
                filterState: FilterState,
                attribute: Attribute,
                numericOperator: Filter.Numeric.Operator,
                `operator`: RefinementOperator = .and,
                groupName: String? = nil) {
      self.interactor = interactor
      self.filterState = filterState
      self.attribute = attribute
      self.numericOperator = numericOperator
      self.operator = `operator`
      self.groupName = groupName
    }

    public func connect() {

      let groupName = self.groupName ?? attribute.rawValue

      switch `operator` {
      case .and:
        connectFilterState(filterState, to: interactor, attribute: attribute, numericOperator: numericOperator, via: SpecializedAndGroupAccessor(filterState[and: groupName]))
      case .or:
        connectFilterState(filterState, to: interactor, attribute: attribute, numericOperator: numericOperator, via: filterState[or: groupName] )
      }

    }

    public func disconnect() {
      filterState.onChange.cancelSubscription(for: interactor)
      interactor.onNumberComputed.cancelSubscription(for: filterState)
    }

    private func connectFilterState<Accessor: SpecializedGroupAccessor>(_ filterState: FilterState,
                                                                        to interactor: NumberInteractor,
                                                                        attribute: Attribute,
                                                                        numericOperator: Filter.Numeric.Operator,
                                                                        via accessor: Accessor) where Accessor.Filter == Filter.Numeric {
      whenFilterStateChangedUpdateExpression(interactor: interactor, filterState: filterState, attribute: attribute, numericOperator: numericOperator, accessor: accessor)
      whenExpressionComputedUpdateFilterState(interactor: interactor, filterState: filterState, attribute: attribute, numericOperator: numericOperator, accessor: accessor)
    }

    private func whenFilterStateChangedUpdateExpression<Accessor: SpecializedGroupAccessor>(interactor: NumberInteractor,
                                                                                            filterState: FilterState,
                                                                                            attribute: Attribute,
                                                                                            numericOperator: Filter.Numeric.Operator,
                                                                                            accessor: Accessor) where Accessor.Filter == Filter.Numeric {

      func extractValue(from numericFilter: Filter.Numeric) -> Number? {
        if case .comparison(numericOperator, let value) = numericFilter.value {
          return Number(value)
        } else {
          return nil
        }
      }

      filterState.onChange.subscribePast(with: interactor) { interactor, _ in
        interactor.item = accessor.filters(for: attribute).compactMap(extractValue).first
      }

    }

    private func whenExpressionComputedUpdateFilterState<P: SpecializedGroupAccessor>(interactor: NumberInteractor,
                                                                                      filterState: FilterState,
                                                                                      attribute: Attribute,
                                                                                      numericOperator: Filter.Numeric.Operator,
                                                                                      accessor: P) where P.Filter == Filter.Numeric {

      let removeCurrentItem = { [weak interactor] in
        guard let item = interactor?.item else { return }
        let filter = Filter.Numeric(attribute: attribute, operator: numericOperator, value: item.toDouble())
        accessor.remove(filter)
      }

      let addItem: (Number?) -> Void = { value in
        guard let value = value else { return }
        let filter = Filter.Numeric(attribute: attribute, operator: numericOperator, value: value.toDouble())
        accessor.add(filter)
      }

      interactor.onNumberComputed.subscribePast(with: filterState) { filterState, computed in
        removeCurrentItem()
        addItem(computed)
        filterState.notifyChange()
      }

    }

  }

}

public extension NumberInteractor {

  @discardableResult func connectFilterState(_ filterState: FilterState,
                                             attribute: Attribute,
                                             numericOperator: Filter.Numeric.Operator,
                                             operator: RefinementOperator = .and,
                                             groupName: String? = nil) -> FilterStateConnection {
    let connection = FilterStateConnection(interactor: self,
                                           filterState: filterState,
                                           attribute: attribute,
                                           numericOperator: numericOperator,
                                           operator: `operator`,
                                           groupName: groupName)
    connection.connect()
    return connection
  }

}
