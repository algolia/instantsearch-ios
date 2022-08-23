//
//  Log+InstantSearch.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 31/01/2020.
//

import Foundation
#if !InstantSearchCocoaPods
import Logging
import struct InstantSearchInsights.Logs
import protocol InstantSearchInsights.LogCollectable
#endif

struct Log: LogCollectable {

  static var logger: Logging.Logger = {
    NotificationCenter.default.addObserver(forName: Logs.logLevelChangeNotficationName, object: nil, queue: .main) { notification in
      if let logLevel = notification.userInfo?["logLevel"] as? LogLevel {
        Log.logger.logLevel = logLevel.swiftLogLevel
      }
    }
    var logger = Logging.Logger(label: "InstantSearch")
    logger.logLevel = Logs.logSeverityLevel.swiftLogLevel
    return logger
  }()

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
