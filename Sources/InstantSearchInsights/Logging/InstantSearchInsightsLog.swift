//
//  InstantSearchInsightsLog.swift
//
//
//  Created by Vladislav Fitc on 18/08/2022.
//

import Foundation
import Logging

typealias Logger = Logging.Logger

class InstantSearchInsightsLog: LogCollectable {
  static var logger: Logging.Logger = {
    subscribeForLogLevelChange { logLevel in
      InstantSearchInsightsLog.logger.logLevel = logLevel
    }
    var logger = Logging.Logger(label: "InstantSearchInsights")
    logger.logLevel = Logs.logSeverityLevel.swiftLogLevel
    return logger
  }()

  static func subscribeForLogLevelChange(_ handler: @escaping (Logging.Logger.Level) -> Void) {
    NotificationCenter.default.addObserver(forName: Notification.Name("com.algolia.logLevelChange"), object: nil, queue: .main) { notification in
      if let logLevel = notification.userInfo?["logLevel"] as? LogLevel {
        handler(logLevel.swiftLogLevel)
      }
    }
  }

  private init() {}
}
