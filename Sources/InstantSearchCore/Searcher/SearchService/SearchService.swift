//
//  SearchService.swift
//  
//
//  Created by Vladislav Fitc on 25/11/2020.
//

import Foundation
import AlgoliaSearchClient

public protocol SearchService {
  
  associatedtype Request
  associatedtype Result
  associatedtype Process = Void
  
  func search(_ request: Request, completion: @escaping (Swift.Result<Result, Error>) -> Void) -> Process
  
}
