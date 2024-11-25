//
//  Snippet.swift
//  
//
//  Created by Vladislav Fitc on 11.03.2020.
//

import Foundation

public struct Snippet: Codable, URLEncodable, Equatable {

  /**
   Attribute to snippet.
   - Use "*" to snippet all attributes.
   */
  public let attribute: Attribute

  /**
   Optional word count.
   - Engine default: 10
   */
  public var count: Int?

  public init(attribute: Attribute, count: Int? = nil) {
    self.attribute = attribute
    self.count = count
  }

}

extension Snippet: Builder {}

extension Snippet: RawRepresentable {

  public var rawValue: String {
    guard let countSuffix = count.flatMap({ ":\($0)" }) else {
      return attribute.rawValue
    }
    return attribute.rawValue + countSuffix
  }

  public init(rawValue: String) {
    let components = rawValue.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
    if let count = components.last.flatMap({ Int(String($0)) }), components.count == 2 {
      self.attribute = Attribute(rawValue: String(components[0]))
      self.count = count
    } else {
      self.attribute = Attribute(rawValue: rawValue)
      self.count = nil
    }
  }

}
