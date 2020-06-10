//
//  TestCredentials.swift
//  
//
//  Created by Vladislav Fitc on 05/06/2020.
//

import Foundation
import AlgoliaSearchClientSwift

struct TestCredentials: Credentials {

  let applicationID: ApplicationID
  let apiKey: APIKey

  static let search: TestCredentials? = {
    if
      let appID = String(environmentVariable: "ALGOLIA_APPLICATION_ID_1"),
      let apiKey = String(environmentVariable: "ALGOLIA_ADMIN_KEY_1") {
      return TestCredentials(applicationID: ApplicationID(rawValue: appID), apiKey: APIKey(rawValue: apiKey))
    } else {
      return nil
    }
  }()

  static let places: TestCredentials? = {
    if
      let appID = String(environmentVariable: "ALGOLIA_PLACES_APPLICATION_ID"),
      let apiKey = String(environmentVariable: "ALGOLIA_PLACES_API_KEY") {
      return TestCredentials(applicationID: ApplicationID(rawValue: appID), apiKey: APIKey(rawValue: apiKey))
    } else {
      return nil
    }
  }()

}

extension String {

  init?(environmentVariable: String) {
    if
      let rawValue = getenv(environmentVariable),
      let value = String(utf8String: rawValue) {
      self = value
    } else {
      return nil
    }
  }

}
