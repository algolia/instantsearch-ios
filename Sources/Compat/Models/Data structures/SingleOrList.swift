//
//  SingleOrList.swift
//  
//
//  Created by Vladislav Fitc on 07/07/2020.
//

import Foundation

public enum SingleOrList<T> {
  case single(T)
  case list([T])
}

extension SingleOrList: Equatable where T: Equatable {

  public static func == (lhs: SingleOrList<T>, rhs: SingleOrList<T>) -> Bool {
    switch (lhs, rhs) {
    case (.single(let left), .single(let right)):
      return left == right
    case (.list(let left), .list(let right)):
      return left == right
    default:
      return false
    }
  }

}

extension SingleOrList: Encodable where T: Encodable {

  public func encode(to encoder: Encoder) throws {
    switch self {
    case .single(let value):
      try value.encode(to: encoder)
    case .list(let list):
      try list.encode(to: encoder)
    }
  }

}

extension SingleOrList: Decodable where T: Decodable {
  public init(from decoder: Decoder) throws {
    if let list = try? [T](from: decoder) {
      self = .list(list)
    } else {
      self = .single(try T(from: decoder))
    }
  }

}
