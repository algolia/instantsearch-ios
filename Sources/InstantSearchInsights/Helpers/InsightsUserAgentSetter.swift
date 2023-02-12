//
//  InsightsUserAgentSetter.swift
//
//
//  Created by Vladislav Fitc on 03/02/2023.
//

import AlgoliaSearchClient
import Foundation

struct InsightsUserAgentSetter {
  /// Add the library's version to the client's user agents, if not already present.
  static let set = Self()

  init() {
    UserAgentController.append(UserAgent(title: "Algolia insights for iOS", version: Version.current.description))
  }
}
