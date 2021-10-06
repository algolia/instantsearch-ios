//
//  UserAgentSetter.swift
//  
//
//  Created by Vladislav Fitc on 16/06/2020.
//

import Foundation

struct UserAgentSetter {

  /// Add the library's version to the client's user agents, if not already present.
  static let set = Self()

  init() {
    UserAgentController.append(UserAgent(title: "InstantSearch iOS", version: Version.current.description))
    UserAgentController.append(Telemetry.shared)
  }

}
