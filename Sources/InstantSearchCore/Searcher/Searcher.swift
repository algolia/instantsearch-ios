//
//  Searcher.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 05/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClientSwift
/// Protocol describing an entity capable to perform search requests
public protocol Searcher: class {

  /// Current query string
  var query: String? { get set }

  /// Triggered when query execution started or stopped
  /// - Parameter: boolean value equal to true if query execution started, false otherwise
  var isLoading: Observer<Bool> { get }

  /// Triggered when query text changed
  /// - Parameter: a new query text value
  var onQueryChanged: Observer<String?> { get }

  /// Launches search query execution with current query text value
  func search()

  /// Stops search query execution
  func cancel()

}

/// Protocol describing an entity capable to receive search result
public protocol SearchResultObservable {

  /// Search result type
  associatedtype SearchResult

  /// Triggered when a new search result received
  var onResults: Observer<SearchResult> { get }

}

extension Searcher {

  func transform<T: Decodable>(content: [String: Any]?, error: Error?) -> Result<T, Error> {
    let result = Result(value: content, error: error)

    switch result {
    case .success(let value):
      do {
        let data = try JSONSerialization.data(withJSONObject: value, options: [])
        let decoder = JSONDecoder()

        let result = try decoder.decode(T.self, from: data)
        return .success(result)
      } catch let error {
        return .failure(error)
      }

    case .failure(let error):
      return .failure(error)
    }

  }

  /// Add the library's version to the client's user agents, if not already present.
  func updateClientUserAgents() {
    let bundle = Bundle(for: type(of: self))
    if let version = bundle.infoDictionary?["CFBundleShortVersionString"] as? String,
      let name = bundle.infoDictionary?["CFBundleName"] as? String {
      let libraryVersion = UserAgent(title: name, version: version)
      SearchClient.append(userAgent: libraryVersion)
    }

  }

}

extension Searcher where Self: SequencerDelegate {

  func didChangeOperationsState(hasPendingOperations: Bool) {
    isLoading.fire(hasPendingOperations)
  }

}

// MARK: - Miscellaneous

/// The operating system's name.
///
/// - returns: The operating system's name, or nil if it could not be determined.
///
internal var osName: String? {
  #if os(iOS)
  return "iOS"
  #elseif os(OSX)
  return "macOS"
  #elseif os(tvOS)
  return "tvOS"
  #elseif os(watchOS)
  return "watchOS"
  #else
  return nil
  #endif
}
