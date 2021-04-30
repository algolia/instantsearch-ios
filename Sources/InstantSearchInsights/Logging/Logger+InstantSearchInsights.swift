//
//  Logger+InstantSearchInsights.swift
//  
//
//  Created by Vladislav Fitc on 19/10/2020.
//

import Foundation
import Logging

public struct Logger {

  struct InstantSearchInsights: LogCollector {

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
      var swiftLog = Logging.Logger(label: "com.algolia.InstantSearchInsights")
      swiftLog.logLevel = .info
      swiftLog.info("Default minimal log severity level is info. Change Logger.InstantSearchInsights.minLogSeverityLevel value if you want to change it.")
      return swiftLog
    }()

    public static func log(level: LogLevel, message: String) {
      guard Logger.InstantSearchInsights.isEnabled else { return }
      service.log(level: level, message: message)
    }

  }

}
