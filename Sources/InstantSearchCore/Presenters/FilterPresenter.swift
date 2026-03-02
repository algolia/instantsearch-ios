//
//  FilterPresenter.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 17/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias FilterPresenter = (Filter) -> String

public extension DefaultPresenter {
  enum Filter {
    public static let present: FilterPresenter = { filter in
      let attributeName = filter.filter.attribute

      switch filter {
      case let .facet(facetFilter):
        switch facetFilter.value {
        case .bool:
          return attributeName

        case let .number(numberValue):
          return "\(attributeName): \(numberValue)"

        case let .string(stringValue):
          return stringValue
        }

      case let .numeric(numericFilter):

        switch numericFilter.value {
        case let .comparison(compOperator, value):
          return "\(attributeName) \(compOperator.rawValue) \(value)"

        case let .range(range):
          return "\(attributeName): \(range.lowerBound) to \(range.upperBound)"
        }

      case let .tag(tagFilter):
        return tagFilter.value
      }
    }
  }
}
