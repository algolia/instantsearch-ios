//
//  IndexQueryState.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 27/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

@_exported import Core
@_exported import Search
import Foundation

/// Helper protocol enabling `set`-style value updates for structs.
public protocol Builder {}

public extension Builder {
  func set<Value>(_ keyPath: WritableKeyPath<Self, Value>, to value: Value) -> Self {
    var copy = self
    copy[keyPath: keyPath] = value
    return copy
  }
}

extension SearchSearchParamsObject: Builder {}
extension Search.SearchResponse: Builder {}
extension Search.SearchResponses: Builder {}
extension Search.IndexSettings: Builder {}
extension Search.Rule: Builder {}
extension Search.SearchConsequence: Builder {}
extension Search.SearchCondition: Builder {}
/// Structure containing all necessary components to perform a search

public struct IndexQueryState {
  /// Index in which search will be performed
  public var indexName: String

  /// Query describing a search request
  public var query: Query

  public init(indexName: String, query: Query = .init()) {
    self.indexName = indexName
    self.query = query
  }
}

extension IndexQueryState: Builder {}

@available(*, deprecated, message: "Use String index names directly; SearchClient no longer provides initIndex.")
extension Array where Element == IndexQueryState {
  init(indices: [String], query: Query = .init()) {
    self = indices.map { IndexQueryState(indexName: $0, query: query) }
  }
}
