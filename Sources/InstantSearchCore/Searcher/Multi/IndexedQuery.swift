//
//  IndexedQuery.swift
//  InstantSearchCore
//

import Foundation

/// Search query tied to a single index.
public struct IndexedQuery: Hashable {
  public var indexName: String
  public var query: SearchSearchParamsObject

  public init(indexName: String, query: SearchSearchParamsObject) {
    self.indexName = indexName
    self.query = query
  }
}

public typealias IndexQuery = IndexedQuery

