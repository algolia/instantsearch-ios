//
//  LanguageFeature.swift
//  
//
//  Created by Vladislav Fitc on 21/04/2020.
//

import Foundation

public enum LanguageFeature {

  /// Enables language feature functionality.
  /// The languages supported here are either every language (this is the default, see list of Language),
  /// or those set by queryLanguages. See queryLanguages example below.
  case `true`

  /// Disables language feature functionality.
  case `false`

  /// A list of Language for which language feature should be enabled.
  /// This list of queryLanguages will override any values that you may have set in Settings.
  case queryLanguages([Language])

}

extension LanguageFeature: ExpressibleByBooleanLiteral {

  public init(booleanLiteral value: Bool) {
    self = value ? .true : .false
  }

}

extension LanguageFeature: ExpressibleByArrayLiteral {

  public init(arrayLiteral elements: Language...) {
    self = .queryLanguages(elements)
  }

}

extension LanguageFeature: Encodable {

  public func encode(to encoder: Encoder) throws {
    var singleValueContainer = encoder.singleValueContainer()
    switch self {
    case .true:
      try singleValueContainer.encode(true)
    case .false:
      try singleValueContainer.encode(false)
    case .queryLanguages(let languages):
      try singleValueContainer.encode(languages)
    }
  }

}

extension LanguageFeature: Decodable {

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let boolContainer = try? container.decode(BoolContainer.self) {
      self = boolContainer.rawValue ? .true : .false
    } else {
      let languages = try container.decode([Language].self)
      self = .queryLanguages(languages)
    }
  }

}

extension LanguageFeature: Equatable {}

extension LanguageFeature: URLEncodable {

  public var urlEncodedString: String {
    switch self {
    case .false:
      return String(false)
    case .true:
      return String(true)
    case .queryLanguages(let languages):
      return languages.map(\.rawValue).joined(separator: ",")
    }
  }

}
