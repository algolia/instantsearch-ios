//
//  AdvancedSyntaxFeatures.swift
//  
//
//  Created by Vladislav Fitc on 12.03.2020.
//

import Foundation

public struct AdvancedSyntaxFeatures: StringOption, ProvidingCustomOption, URLEncodable {

  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }

  /// A specific sequence of terms that must be matched next to one another. A phrase query needs to be surrounded by double quotes (").
  /// For example, "search engine" will only match records having search next to engine.
  public static var exactPhrase: Self { .init(rawValue: #function) }

  /// Excludes records that contain a specific term. This term has to be prefixed by a minus (-).
  /// For example, search -engine will only match records containing search but not engine.
  public static var excludeWords: Self { .init(rawValue: #function) }

}
