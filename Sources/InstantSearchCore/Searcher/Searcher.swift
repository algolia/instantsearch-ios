//
//  Searcher.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 05/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient

/// Protocol describing an entity capable to perform search requests
public protocol Searcher: AnyObject, Searchable {

  /// Current query string
  var query: String? { get set }

  /// Triggered when query text changed
  /// - Parameter: a new query text value
  var onQueryChanged: Observer<String?> { get }

  /// Triggered when query execution started or stopped
  /// - Parameter: boolean value equal to true if query execution started, false otherwise
  var isLoading: Observer<Bool> { get }

  /// Triggered when a search operation launched
  var onSearch: Observer<Void> { get }

  /// Launches search query execution with current query text value
  func search()

  /// Stops search query execution
  func cancel()

}

public protocol Searchable {
  func search()
}

/// Protocol describing an entity capable to receive search result
public protocol SearchResultObservable {

  /// Search result type
  associatedtype SearchResult

  /// Triggered when a new search result received
  var onResults: Observer<SearchResult> { get }

}

/// Protocol describing an entity capable to provide an error
public protocol ErrorObservable {

  /// Triggered when an error occured
  var onError: Observer<Error> { get }

}

extension Searcher {

  /// Add the library's version to the client's user agents, if not already present.
  func updateClientUserAgents() {
    _ = UserAgentSetter.set
  }

}

extension Searcher where Self: SequencerDelegate {

  func didChangeOperationsState(hasPendingOperations: Bool) {
    isLoading.fire(hasPendingOperations)
  }

}
