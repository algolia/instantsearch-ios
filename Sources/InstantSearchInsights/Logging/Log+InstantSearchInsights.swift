//
//  Log+InstantSearchInsights.swift
//  
//
//  Created by Vladislav Fitc on 18/08/2022.
//

import Foundation
import Logging

typealias Logger = Logging.Logger

class Log: LogCollectable {

  static var logger: Logging.Logger = {
    subscribeForLogLevelChange { logLevel in
      Log.logger.logLevel = logLevel
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

public protocol LogCollectable {
  static var logger: Logging.Logger { get }
}

public extension LogCollectable {
  
  static func trace(_ message: String) {
    logger.log(level: .trace, "\(message)")
  }

  static func debug(_ message: String) {
    logger.log(level: .debug, "\(message)")
  }

  static func info(_ message: String) {
    logger.log(level: .info, "\(message)")
  }

  static func notice(_ message: String) {
    logger.log(level: .notice, "\(message)")
  }

  static func warning(_ message: String) {
    logger.log(level: .warning, "\(message)")
  }

  static func error(_ message: String) {
    logger.log(level: .error, "\(message)")
  }

  static func critical(_ message: String) {
    logger.log(level: .critical, "\(message)")
  }

}
