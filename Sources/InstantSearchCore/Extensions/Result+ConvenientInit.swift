//
//  Result.swift
//  InstantSearchCore-iOS
//
//  Created by Guy Daher on 07/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension Result where Failure == Error {
  init(value: Success?, error: Failure?) {
    switch (value, error) {
    case let (_, .some(error)):
      self = .failure(error)
    case let (.some(value), _):
      self = .success(value)
    default:
      self = .failure(ResultError.invalidResultInput)
    }
  }
}

public extension Result where Success: Decodable, Failure == Error {
  init(rawValue: [String: Any]?, error: Failure?) {
    switch (rawValue, error) {
    case let (.none, .some(error)):
      self = .failure(error)
    case let (.some(rawValue), .none):
      do {
        let data = try JSONSerialization.data(withJSONObject: rawValue, options: [])
        let decoder = JSONDecoder()
        let result = try decoder.decode(Success.self, from: data)
        self = .success(result)
      } catch {
        self = .failure(error)
      }
    default:
      self = .failure(ResultError.invalidResultInput)
    }
  }
}

public enum ResultError: Error {
  case invalidResultInput
}
