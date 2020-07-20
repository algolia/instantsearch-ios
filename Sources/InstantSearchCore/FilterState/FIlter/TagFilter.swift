//
//  Tag.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 10/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/** Defines tag filter
 # See also:
 [Reference](https:www.algolia.com/doc/guides/managing-results/refine-results/filtering/how-to/filter-by-tags/)
 */

public extension Filter {

  struct Tag: FilterType, Equatable {

    public let attribute: Attribute = .tags
    public var isNegated: Bool
    public let value: String

    public init(value: String, isNegated: Bool = false) {
      self.isNegated = isNegated
      self.value = value
    }

  }

}

extension Filter.Tag: Hashable {}

extension Filter.Tag: ExpressibleByStringLiteral {

  public typealias StringLiteralType = String

  public init(stringLiteral string: String) {
    self.init(value: string, isNegated: false)
  }

}

extension Filter.Tag: CustomStringConvertible {

  public var description: String {
    return "\(value)"
  }

}
