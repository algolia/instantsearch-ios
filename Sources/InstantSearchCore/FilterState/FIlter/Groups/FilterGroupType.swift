//
//  FilterGroup.swift
//  AlgoliaSearch
//
//  Created by Guy Daher on 14/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

public enum FilterGroup {}

public protocol FilterGroupType {

  var name: String? { get }
  var filters: [FilterType] { get }
  var isDisjuncitve: Bool { get }

  func withFilters<S: Sequence>(_ filters: S) -> Self where S.Element == FilterType

}

extension FilterGroupType {

  var isConjunctive: Bool {
    return !isDisjuncitve
  }

  public var isEmpty: Bool {
    return filters.isEmpty
  }

  func contains(_ filter: FilterType) -> Bool {
    return filters.contains(where: { Filter($0) == Filter(filter) })
  }

}

public typealias FilterGroupDescriptor = (groupName: String, groupType: RefinementOperator)
