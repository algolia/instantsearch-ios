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
      let attributeName = filter.filter.attribute.rawValue

      switch filter {
      case .facet(let facetFilter):
        switch facetFilter.value {
        case .bool:
          return filter.filter.attribute.rawValue

        case .float(let floatValue):
          return "\(attributeName): \(floatValue)"

        case .string(let stringValue):
          return stringValue
        }

      case .numeric(let numericFilter):

        switch numericFilter.value {
        case .comparison(let compOperator, let value):
          return "\(attributeName) \(compOperator) \(value)"

        case .range(let range):
          return "\(attributeName): \(range.lowerBound) to \(range.upperBound)"
        }

      case .tag(let tagFilter):
        return tagFilter.value
      }
    }

  }

}
