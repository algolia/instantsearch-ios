//
//  CompositeSearchSource.swift
//  
//
//  Created by Vladislav Fitc on 08/09/2021.
//

import Foundation

public protocol CompositeSearchSource {
  
  associatedtype RequestUnit
  associatedtype ResultUnit
  
  /// Returns the list of queries and the completion that might be called with for the result of these queries
  func collect() -> (queries: [RequestUnit], completion: (Result<[ResultUnit], Error>) -> Void)
  
}

/// Type-erased wrapper for a CompositeSearchSource instance
class AnyCompositeSearchSource<RequestUnit, ResultUnit>: CompositeSearchSource {

  let wrapped: Any
  let collectClosure: () -> (queries: [RequestUnit], completion: (Result<[ResultUnit], Error>) -> Void)
  
  init<T: CompositeSearchSource>(wrapped: T) where T.RequestUnit == RequestUnit, T.ResultUnit == ResultUnit {
    self.wrapped = wrapped
    self.collectClosure = wrapped.collect
  }
  
  func collect() -> (queries: [RequestUnit], completion: (Result<[ResultUnit], Error>) -> Void) {
    return collectClosure()
  }
  
}
