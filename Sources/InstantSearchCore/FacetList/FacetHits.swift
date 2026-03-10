//
//  FacetHits.swift
//  InstantSearchCore
//

import Foundation
import AlgoliaCore

public typealias FacetHits = AlgoliaSearch.FacetHits

public extension FacetHits {
  init(value: String, count: Int) {
    self.init(value: value, highlighted: value, count: count)
  }

  var isEmpty: Bool {
    return count == 0
  }
}

extension FacetHits: @retroactive CustomStringConvertible {
  public var description: String {
    return value
  }
}
