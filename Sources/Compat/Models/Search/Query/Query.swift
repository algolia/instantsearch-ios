//
//  Query.swift
//
//
//  Created by Vladislav Fitc on 17.02.2020.
//

import Foundation

public struct Query: Equatable, SearchParameters {

  internal var searchParametersStorage: SearchParametersStorage

  /// Custom parameters
  public var customParameters: [String: JSON]?

  public init(_ query: String? = nil) {
    searchParametersStorage = .init()
    self.searchParametersStorage.query = query
  }

  static let empty = Query()

}

extension Query: Codable {

  public init(from decoder: Decoder) throws {
    self.searchParametersStorage = try .init(from: decoder)
    customParameters = try CustomParametersCoder.decode(from: decoder, excludingKeys: SearchParametersStorage.CodingKeys.self)
  }

  public func encode(to encoder: Encoder) throws {
    try searchParametersStorage.encode(to: encoder)
    if let customParameters = customParameters {
      try CustomParametersCoder.encode(customParameters, to: encoder)
    }
  }

}

extension Query: SearchParametersStorageContainer {

}

extension Query: Builder {}

extension Query: ExpressibleByStringInterpolation {

  public init(stringLiteral value: String) {
    self.init(value)
  }

}
