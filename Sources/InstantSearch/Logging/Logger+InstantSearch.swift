//
//  Logging+InstantSearch.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 31/01/2020.
//

import Logging
#if !InstantSearchCocoaPods
import struct InstantSearchInsights.Logger
import enum InstantSearchInsights.LogLevel
import protocol InstantSearchInsights.LogCollector
import protocol InstantSearchInsights.LogService
#endif

public extension Logger {

  struct InstantSearch: LogCollector {

    public static var minLogSeverityLevel: LogLevel {

      get {
        return service.minLogSeverityLevel
      }

      set {
        service.minLogSeverityLevel = newValue
      }

    }

    public static var isEnabled: Bool = true

    static var service: LogService = {
      var swiftLog = Logging.Logger(label: "com.algolia.InstantSearch")
      swiftLog.logLevel = .info
      swiftLog.info("Default minimal log severity level is info. Change Logger.InstantSearch.minLogSeverityLevel value if you want to change it.")
      return swiftLog
    }()

    public static func log(level: LogLevel, message: String) {
      guard Logger.InstantSearch.isEnabled else { return }
      service.log(level: level, message: message)
    }

  }

}

typealias InstantSearchLogger = Logger.InstantSearch

extension InstantSearchLogger {

  static func missingHitsSourceWarning() {
    warning("Missing hits source")
  }

  static func missingCellConfiguratorWarning(forSection section: Int) {
    warning("No cell configurator found for section \(section)")
  }

  static func missingClickHandlerWarning(forSection section: Int) {
    warning("No click handler found for section \(section)")
  }

  static func error(_ error: Error) {
    self.error("\(error)")
  }

}
