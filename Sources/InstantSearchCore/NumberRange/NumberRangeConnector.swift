//
//  NumberRangeConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that applies a numeric range filter
public class NumberRangeConnector<Number: Comparable & DoubleRepresentable> {
  
  /// Searcher that handles your searches.
  public let searcher: SingleIndexSearcher
  
  /// Filter state holding your filters
  public let filterState: FilterState
  
  /// Attribute to filter
  public let attribute: Attribute
  
  /// Business logic applied to a numeric range filter
  public let interactor: NumberRangeInteractor<Number>
  
  /// Connection between interactor and searcher
  public let searcherConnection: Connection

  /// Connection between interactor and filter state
  public let filterStateConnection: Connection
  
  /**
   - Parameters:
     - searcher: Searcher that handles your searches.
     - filterState: Filter state holding your filters
     - attribute: Attribute to filter
     - interactor: The logic applied to the numeric range
     - operator: Whether the filter is added to a conjuncitve(`and`) or a disjuncitve (`or`) group in the filter state. Default value: .and
     - groupName: Filter group name in the filter state. If not specified, the attribute value is used as the group name
  */
  
  public init(searcher: SingleIndexSearcher,
              filterState: FilterState,
              attribute: Attribute,
              interactor: NumberRangeInteractor<Number>,
              operator: RefinementOperator = .and,
              groupName: String? = nil) {
    self.searcher = searcher
    self.filterState = filterState
    self.attribute = attribute
    self.interactor = interactor
    self.searcherConnection = interactor.connectSearcher(searcher, attribute: attribute)
    self.filterStateConnection = interactor.connectFilterState(filterState,
                                                               attribute: attribute,
                                                               operator: `operator`,
                                                               groupName: groupName)
  }
  
  /**
   - Parameters:
     - searcher: Searcher that handles your searches.
     - filterState: Filter state holding your filters
     - attribute: Attribute to filter with a numeric range
     - bounds: Optional bounds limiting the max and the min value of the range
     - range: Initial range value
     - operator: Whether the filter is added to a conjuncitve(`and`) or  a disjuncitve (`or`) group in the filter state. Default value: .and
     - groupName: Filter group name in the filter state. If not specified, the attribute value is used as the group name
  */
  public convenience init(searcher: SingleIndexSearcher,
                          filterState: FilterState,
                          attribute: Attribute,
                          bounds: ClosedRange<Number>? = nil,
                          range: ClosedRange<Number>? = nil,
                          `operator`: RefinementOperator = .and,
                          groupName: String? = nil) {
    let interactor = NumberRangeInteractor(item: range)
    interactor.applyBounds(bounds: bounds)
    self.init(searcher: searcher,
              filterState: filterState,
              attribute: attribute,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName)
  }
  
}

extension NumberRangeConnector: Connection {
  
  public func connect() {
    filterStateConnection.connect()
  }
  
  public func disconnect() {
    filterStateConnection.disconnect()
  }
  
}
