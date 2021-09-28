//
//  MultiSearchComponent.swift
//  
//
//  Created by Vladislav Fitc on 08/09/2021.
//

import Foundation

/// A Searcher providing a list of sub-requests to perform and a closure accepting a list of sub-results
public protocol MultiSearchComponent {

  associatedtype SubRequest
  associatedtype SubResult

  /// Returns the list of queries and the completion that might be called with for the result of these queries
  func collect() -> (requests: [SubRequest], completion: (Result<[SubResult], Error>) -> Void)

}

/// Type-erased wrapper for a SubSearcher instance
class AnyMultiSearchComponent<SubRequest, SubResult>: MultiSearchComponent {

  let wrapped: Any
  let collectClosure: () -> (requests: [SubRequest], completion: (Result<[SubResult], Error>) -> Void)

  init<T: MultiSearchComponent>(wrapped: T) where T.SubRequest == SubRequest, T.SubResult == SubResult {
    self.wrapped = wrapped
    self.collectClosure = wrapped.collect
  }

  func collect() -> (requests: [SubRequest], completion: (Result<[SubResult], Error>) -> Void) {
    return collectClosure()
  }

}
