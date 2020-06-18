//
//  IndexQueryState.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 27/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@_exported import AlgoliaSearchClient
/// Structure containing all necessary components to perform a search

public struct IndexQueryState {

  /// Index in which search will be performed
  public var indexName: IndexName

  /// Query describing a search request
  public var query: Query

  public init(indexName: IndexName, query: Query = .init()) {
    self.indexName = indexName
    self.query = query
  }

}

extension IndexQueryState: Builder {}

extension Array where Element == IndexQueryState {

  init(indices: [AlgoliaSearchClient.Index], query: Query = .init()) {
    self = indices.map { IndexQueryState(indexName: $0.name, query: query) }
  }

}
