//
//  AlternativesAsExact.swift
//  
//
//  Created by Vladislav Fitc on 12.03.2020.
//

import Foundation

public struct AlternativesAsExact: StringOption, ProvidingCustomOption, URLEncodable {

  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }

  /// Alternative words added by the ignorePlurals feature.
  public static var ignorePlurals: Self { .init(rawValue: #function) }

  /// Single-word synonyms (example: “NY” = “NYC”).
  public static var singleWordSynonym: Self { .init(rawValue: #function) }

  /// Multiple-words synonyms (example: “NY” = “New York”).
  public static var multiWordsSynonym: Self { .init(rawValue: #function) }

}
