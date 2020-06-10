//
//  Logging.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 31/01/2020.
//

import Foundation
import Logging

typealias SwiftLog = Logging.Logger

struct Logger {
  
  static var loggingService: Loggable = SwiftLog(label: "com.algolia.InstantSearch")
  
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

enum LogLevel {
  case trace, debug, info, notice, warning, error, critical
}

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

extension LogLevel {
  
  var swiftLogLevel: SwiftLog.Level {
    switch self {
    case .trace: return .trace
    case .debug: return .debug
    case .info: return .info
    case .notice: return .notice
    case .warning: return .warning
    case .error: return .error
    case .critical: return .critical
    }
  }
  
}

protocol Loggable {
  
  func log(level: LogLevel, message: String)
  
}

extension SwiftLog: Loggable {
  
  func log(level: LogLevel, message: String) {
    self.log(level: level.swiftLogLevel, SwiftLog.Message(stringLiteral: message), metadata: .none)
  }
  
}
