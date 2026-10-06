//
//  Hit+Deserialize.swift
//  InstantSearchCore
//

import Foundation

public extension Hit {
  /// Legacy helper for decoding a record from a raw hit dictionary.
  @available(*, deprecated, message: "Use JSONDecoder on Hit.object or HitsInteractor decoding helpers instead.")
  static func deserialize<DecodedRecord: Decodable>(_ json: [String: AlgoliaCore.AnyCodable], jsonDecoder: JSONDecoder = JSONDecoder()) throws -> DecodedRecord {
    let data = try JSONEncoder().encode(json)
    return try jsonDecoder.decode(DecodedRecord.self, from: data)
  }
}
