//
//  Config.swift
//  Insights
//
//  Created by Robert Mogos on 07/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

struct Algolia {
  enum SessionConfig {
    static func `default`(appId _: String, apiKey _: String) -> URLSessionConfiguration {
      let config = URLSessionConfiguration.default
      config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
      config.urlCache = nil
      config.networkServiceType = .background
      return config
    }
  }

  enum Insights {
    // Default flush delay is 30 seconds
    static let flushDelay: TimeInterval = 30

    /// The delay after which the event won't be accepted by server: 4 days
    static let eventExpirationDelay = (4 * 24 * 3600 as TimeInterval).milliseconds

    // Default events batch size
    static let minBatchSize = 10

    /// Maximum number of sync attempts for an events package before it is dropped
    static let maxRetryCount = 20

    /// Upper bound of the exponential backoff delay between sync attempts of a failed package
    static let maxRetryBackoff: TimeInterval = 15 * 60

    /// The delay after which a stored events package is discarded without sending: 4 days,
    /// matching the server-side event acceptance window
    static let packageExpirationDelay: TimeInterval = 4 * 24 * 3600
  }
}
