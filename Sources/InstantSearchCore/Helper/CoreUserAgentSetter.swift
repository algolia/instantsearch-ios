//
//  CoreUserAgentSetter.swift
//
//
//  Created by Vladislav Fitc on 16/06/2020.
//

import AlgoliaCore
import Foundation

struct CoreUserAgentSetter {
  /// Add the library's version to the client's user agents, if not already present.
  static let set = Self()

  init() {
    UserAgentController.append(UserAgent(title: "InstantSearch iOS", version: Version.instantSearch.description))
    UserAgentController.append(Telemetry.shared)
  }
}
