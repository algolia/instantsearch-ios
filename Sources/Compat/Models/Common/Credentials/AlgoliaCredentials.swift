//
//  AlgoliaCredentials.swift
//
//
//  Created by Vladislav Fitc on 05/03/2020.
//

import Core
import Foundation

public struct AlgoliaCredentials: Credentials {
  // FIXME: Credentials in v9 switches to appID and String types
  public var appID: String
  public var apiKey: String
}
