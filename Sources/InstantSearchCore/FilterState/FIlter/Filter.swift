//
//  Filter.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 10/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public enum Filter: Hashable {
  case facet(Facet)
  case numeric(Numeric)
  case tag(Tag)

  public var attribute: Attribute {
    switch self {
    case let .facet(filter):
      return filter.attribute
    case let .numeric(filter):
      return filter.attribute
    case let .tag(filter):
      return filter.attribute
    }
  }

  public init<F: FilterType>(_ filter: F) {
    switch filter {
    case let facetFilter as Filter.Facet:
      self = .facet(facetFilter)
    case let numericFilter as Filter.Numeric:
      self = .numeric(numericFilter)
    case let tagFilter as Filter.Tag:
      self = .tag(tagFilter)
    default:
      fatalError("Filter of type \(F.self) is not supported")
    }
  }

  public init(_ filter: FilterType) {
    switch filter {
    case let facetFilter as Filter.Facet:
      self = .facet(facetFilter)
    case let numericFilter as Filter.Numeric:
      self = .numeric(numericFilter)
    case let tagFilter as Filter.Tag:
      self = .tag(tagFilter)
    default:
      fatalError("Filter of type \(FilterType.self) is not supported")
    }
  }

  public var filter: FilterType {
    switch self {
    case let .facet(facetFilter):
      return facetFilter

    case let .numeric(numericFilter):
      return numericFilter

    case let .tag(tagFilter):
      return tagFilter
    }
  }
}

extension Filter: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .facet(facetFilter):
      return facetFilter.description
    case let .numeric(numericFilter):
      return numericFilter.description
    case let .tag(tagFilter):
      return tagFilter.description
    }
  }
}

/// Abstract filter protocol
public protocol FilterType {
  /// Identifier of field affected by filter
  var attribute: Attribute { get }

  /// A Boolean value indicating whether filter is inverted
  var isNegated: Bool { get set }

  /// Replaces isNegated property by a new value
  /// parameter value: new value of isNegated
  mutating func not(value: Bool)
}

public extension FilterType {
  mutating func not(value: Bool = true) {
    isNegated = value
  }
}

@discardableResult public prefix func ! <T: FilterType>(filter: T) -> T {
  var mutableFilterCopy = filter
  mutableFilterCopy.not(value: !filter.isNegated)
  return mutableFilterCopy
}
