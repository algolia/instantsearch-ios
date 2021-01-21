//
//  SearchService.swift
//  
//
//  Created by Vladislav Fitc on 25/11/2020.
//

import Foundation
import AlgoliaSearchClient

/// Abstract search service
public protocol SearchService {

  /// Encapsulates all the parameters
  associatedtype Request

  /// Search result
  associatedtype Result

  /// Process object manage search operation while it is being executed
  associatedtype Process = Void

  /// Launch search
  func search(_ request: Request, completion: @escaping (Swift.Result<Result, Error>) -> Void) -> Process

}
