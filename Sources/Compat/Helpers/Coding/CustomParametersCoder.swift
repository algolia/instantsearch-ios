//
//  CustomParametersCoder.swift
//  
//
//  Created by Vladislav Fitc on 23/04/2020.
//

import Foundation

struct CustomParametersCoder {

  static func decode<Keys: CaseIterable>(from decoder: Decoder, excludingKeys: Keys.Type) throws -> [String: JSON] where Keys.AllCases.Element: RawRepresentable, Keys.AllCases.Element.RawValue == String {
    return try decode(from: decoder, excludingKeys: excludingKeys.allCases.map(\.rawValue))
  }

  static func decode(from decoder: Decoder, excludingKeys: [String] = []) throws -> [String: JSON] {
    let singleValueContainer = try decoder.singleValueContainer()
    var customParameters = try singleValueContainer.decode([String: JSON].self)
    for key in excludingKeys {
      customParameters.removeValue(forKey: key)
    }
    return customParameters
  }

  static func encode(_ parameters: [String: JSON], to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: DynamicKey.self)
    for (key, value) in parameters {
      try container.encode(value, forKey: DynamicKey(stringValue: key))
    }
  }

}
