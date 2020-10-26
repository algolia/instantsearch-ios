//
//  Config.swift
//  Insights
//
//  Created by Robert Mogos on 07/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

struct Algolia {

  struct SessionConfig {
    static func `default`(appId: String, apiKey: String) -> URLSessionConfiguration {
      let config = URLSessionConfiguration.default
      config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
      config.urlCache = nil
      config.networkServiceType = .background
      return config
    }
  }

  struct Insights {
    // Default flush delay is 30 seconds
    static let flushDelay: TimeInterval = 30

    static let maxEventCountInPackage = 1000
  }

}
