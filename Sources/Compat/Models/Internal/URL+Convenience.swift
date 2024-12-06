//
//  URL+Convenience.swift
//  
//
//  Created by Vladislav Fitc on 18/11/2021.
//

import Foundation

extension URL {

  static var indexesV1 = Self(string: "/1/indexes")!
  static var settings = Self(string: "/settings")!
  static var clustersV1 = Self(string: "/1/clusters")!
  static var synonyms = Self(string: "/synonyms")!
  static var eventsV1 = Self(string: "/1/events")!
  static var ABTestsV2 = Self(string: "/2/abtests")!
  static var keysV1 = Self(string: "/1/keys")!
  static var logs = Self(string: "/1/logs")!
  static var strategies = Self(string: "/1/strategies")!
  static var places = Self(string: "/1/places")!
  static var answers = Self(string: "/1/answers")!
  static var dictionaries = Self(string: "/1/dictionaries")!
  static var task = Self(string: "/1/task")!

  func appending<R: RawRepresentable>(_ rawRepresentable: R) -> Self where R.RawValue == String {
    return appendingPathComponent(rawRepresentable.rawValue.addingPercentEncoding(withAllowedCharacters: .urlPathComponentAllowed)!, isDirectory: false)
  }

  func appending(_ pathComponent: PathComponent) -> Self {
    return appendingPathComponent(pathComponent.rawValue.addingPercentEncoding(withAllowedCharacters: .urlPathComponentAllowed)!, isDirectory: false)
  }

  enum PathComponent: String {

    case search
    case stop
    case clear
    case restore
    case reverse
    case browse
    case deleteByQuery
    case batch

    case partial
    case mapping
    case pending
    case top

    case task
    case query
    case prediction
    case operation

    case languages
    case keys
    case queries
    case objects
    case personalization
    case recommendations
    case rules
    case facets
    case synonyms
    case settings

    case asterisk = "*"

  }

}
