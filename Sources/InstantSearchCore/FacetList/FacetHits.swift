//
//  FacetHits.swift
//  InstantSearchCore
//

import Foundation
import Core

/// Facet hit model returned by facet search requests.
public struct FacetHits: Codable, Hashable {
  public let value: String
  public let highlighted: String
  public let count: Int

  public init(value: String, highlighted: String = "", count: Int) {
    self.value = value
    self.highlighted = highlighted.isEmpty ? value : highlighted
    self.count = count
  }
}

public extension FacetHits {
  var isEmpty: Bool {
    return count == 0
  }
}

extension FacetHits: CustomStringConvertible {
  public var description: String {
    return value
  }
}


