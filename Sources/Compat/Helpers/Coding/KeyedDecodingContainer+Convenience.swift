//
//  KeyedDecodingContainer+Convenience.swift
//  
//
//  Created by Vladislav Fitc on 19/03/2020.
//

import Foundation

extension KeyedDecodingContainer {

  func decode<T: Decodable>(forKey key: K) throws -> T {
    return try decode(T.self, forKey: key)
  }

  func decodeIfPresent<T: Decodable>(forKey key: K) throws -> T? {
    return try decodeIfPresent(T.self, forKey: key)
  }

}
