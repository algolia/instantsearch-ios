//
//  NumberRangeConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class NumberRangeConnector<Number: Comparable & DoubleRepresentable>: Connection {

  public let filterState: FilterState
  public let attribute: Attribute
  public let filterStateConnection: Connection

  public init(filterState: FilterState,
              attribute: Attribute,
              operator: RefinementOperator,
              groupName: String? = nil,
              bounds: ClosedRange<Number>,
              range: ClosedRange<Number>) {
    self.filterState = filterState
    self.attribute = attribute
    let interactor = NumberRangeInteractor(item: range)
    interactor.applyBounds(bounds: bounds)
    self.filterStateConnection = interactor.connectFilterState(filterState,
                                                               attribute: attribute,
                                                               operator: `operator`,
                                                               groupName: groupName)
  }

  public func connect() {
    filterStateConnection.connect()
  }

  public func disconnect() {
    filterStateConnection.disconnect()
  }

}
