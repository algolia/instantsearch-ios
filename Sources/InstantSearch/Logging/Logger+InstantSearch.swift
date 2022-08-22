//
//  Logging+InstantSearch.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 31/01/2020.
//

import Foundation
#if !InstantSearchCocoaPods
import Logging
import struct InstantSearchInsights.Logs
#endif

struct Log {
  
  static var logger: Logging.Logger = {
    NotificationCenter.default.addObserver(forName: Notification.Name("com.algolia.logLevelChange"), object: nil, queue: .main) { notification in
      if let logLevel = notification.userInfo?["logLevel"] as? LogLevel {
        Log.logger.logLevel = logLevel.swiftLogLevel
      }
    }
    var logger = Logging.Logger(label: "InstantSearch")
    logger.logLevel = Logs.logSeverityLevel.swiftLogLevel
    return logger
  }()
  
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

  static func missingHitsSourceWarning() {
    logger.warning("Missing hits source")
  }

  static func missingCellConfiguratorWarning(forSection section: Int) {
    logger.warning("No cell configurator found for section \(section)")
  }

  static func missingClickHandlerWarning(forSection section: Int) {
    logger.warning("No click handler found for section \(section)")
  }

  static func error(_ error: Error) {
    logger.error("\(error)")
  }

}
