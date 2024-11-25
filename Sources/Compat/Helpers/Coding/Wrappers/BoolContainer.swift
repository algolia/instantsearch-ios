//
//  BoolContainer.swift
//  
//
//  Created by Vladislav Fitc on 17/07/2020.
//

import Foundation

/**
 Helper structure ensuring the decoding of a bool value from a "volatile" JSON
 occasionally providing bool values in the form of String   
 */
struct BoolContainer: RawRepresentable, Codable {

  let rawValue: Bool

  init(rawValue: Bool) {
    self.rawValue = rawValue
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let boolValue = try? container.decode(Bool.self) {
      self.rawValue = boolValue
      return
    }
    if let boolFromString = Bool(try container.decode(String.self)) {
      self.rawValue = boolFromString
      return
    }
    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Value cannot be decoded neither to Bool nor to String representing Bool value")
  }

}
