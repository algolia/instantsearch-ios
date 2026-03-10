//
//  IndexQueryState.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 27/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

@_exported import AlgoliaCore
@_exported import AlgoliaSearch
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
extension AlgoliaSearch.SearchResponse: Builder {}
extension AlgoliaSearch.SearchResponses: Builder {}
extension AlgoliaSearch.IndexSettings: Builder {}
extension AlgoliaSearch.Rule: Builder {}
extension AlgoliaSearch.SearchConsequence: Builder {}
extension AlgoliaSearch.SearchCondition: Builder {}
/// Structure containing all necessary components to perform a search

public struct IndexQueryState {
  /// Index in which search will be performed
  public var indexName: String

  /// Query describing a search request
  public var query: SearchSearchParamsObject

  public init(indexName: String, query: SearchSearchParamsObject = .init()) {
    self.indexName = indexName
    self.query = query
  }
}

extension IndexQueryState: Builder {}

@available(*, deprecated, message: "Use String index names directly; SearchClient no longer provides initIndex.")
extension Array where Element == IndexQueryState {
  init(indices: [String], query: SearchSearchParamsObject = .init()) {
    self = indices.map { IndexQueryState(indexName: $0, query: query) }
  }
}
