//
//  Result.swift
//  InstantSearch
//
//  Created by Guy Daher on 18/02/2019.
//

import Foundation

public enum Result<T> {

  case success(T?), fail(Error)

  public init(value: T) {
    self = .success(value)
  }

  public init(error: Error) {
    self = .fail(error)
  }

  public var value: T? {
    if case let .success(val) = self { return val } else { return nil }
  }

  public var error: Error? {
    if case let .fail(err) = self { return err } else { return nil }
  }

}
