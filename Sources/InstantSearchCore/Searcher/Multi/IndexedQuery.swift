//
//  IndexedQuery.swift
//  InstantSearchCore
//

import Foundation

/// Search query tied to a single index.
public struct IndexedQuery: Hashable {
  public var indexName: String
  public var query: Query

  public init(indexName: String, query: Query) {
    self.indexName = indexName
    self.query = query
  }
}

public typealias IndexQuery = IndexedQuery

