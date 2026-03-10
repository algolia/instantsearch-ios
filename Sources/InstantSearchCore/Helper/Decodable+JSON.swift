//
//  Decodable+JSON.swift
//
//
//  Created by Vladislav Fitc on 12/10/2020.
//

import AlgoliaCore
import Foundation

extension Decodable {
  init(json: [String: AlgoliaCore.AnyCodable]) throws {
    let data = try JSONEncoder().encode(json)
    self = try JSONDecoder().decode(Self.self, from: data)
  }
}
