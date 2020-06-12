//
//  Logger.swift
//  
//
//  Created by Vladislav Fitc on 11/06/2020.
//

import Foundation

public struct Logger {

  static var loggingService: Loggable = {
    var swiftLog = SwiftLog(label: "com.algolia.InstantSearchCore")
    print("InstantSearchCore: Default minimal log severity level is info. Change InstantSearchCore.Logger.minLogServerityLevel value if you want to change it.")
    swiftLog.logLevel = .info
    return swiftLog
  }()

  public static var minSeverityLevel: LogLevel {
    get {
      return loggingService.minSeverityLevel
    }

    set {
      loggingService.minSeverityLevel = newValue
    }
  }

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
