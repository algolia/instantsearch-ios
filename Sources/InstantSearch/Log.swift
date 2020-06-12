//
//  Logging.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 31/01/2020.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
import Logging

struct Logger {

  static var loggingService: Loggable = {
    var swiftLog = Logging.Logger(label: "com.algolia.InstantSearch")
    print("InstantSearch: Default minimal log severity level is info. Change InstantSearch.Logger.minLogServerityLevel value if you want to change it.")
    swiftLog.logLevel = .info
    return swiftLog
  }()

  private init() {}

  static func trace(_ message: String) {
    loggingService.log(level: .trace, message: message)
  }

  static func debug(_ message: String) {
    loggingService.log(level: .debug, message: message)
  }

  static func info(_ message: String) {
    loggingService.log(level: .info, message: message)
  }

  static func notice(_ message: String) {
    loggingService.log(level: .notice, message: message)
  }

  static func warning(_ message: String) {
    loggingService.log(level: .warning, message: message)
  }

  static func error(_ message: String) {
    loggingService.log(level: .error, message: message)
  }

  static func critical(_ message: String) {
    loggingService.log(level: .critical, message: message)
  }

}
#endif

extension Logger {

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
