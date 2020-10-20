//
//  Logger.swift
//  
//
//  Created by Vladislav Fitc on 19/10/2020.
//

import Foundation
import Logging

typealias SwiftLog = Logging.Logger

extension SwiftLog: Loggable {

  public var minSeverityLevel: LogLevel {
    get {
      return LogLevel(swiftLogLevel: logLevel)
    }
    set {
      self.logLevel = newValue.swiftLogLevel
    }
  }

  public func log(level: LogLevel, message: String) {
    self.log(level: level.swiftLogLevel, SwiftLog.Message(stringLiteral: message), metadata: .none)
  }

}

extension LogLevel {

  init(swiftLogLevel: SwiftLog.Level) {
    switch swiftLogLevel {
    case .trace: self = .trace
    case .debug: self = .debug
    case .info: self = .info
    case .notice: self = .notice
    case .warning: self = .warning
    case .error: self = .error
    case .critical: self = .critical
    }
  }

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

public enum LogLevel {
  case trace, debug, info, notice, warning, error, critical
}

public protocol Loggable {

  var minSeverityLevel: LogLevel { get set }

  func log(level: LogLevel, message: String)

}

//"[Algolia Insights - \(appId)] \(message)"/

public struct Logger {

  static var loggingService: Loggable = {
    var swiftLog = SwiftLog(label: "com.algolia.InstantSearchInsights")
    print("InstantSearch Insights: Default minimal log severity level is info. Change InstantSearchInsights.Logger.minLogServerityLevel value if you want to change it.")
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

  let prefix: String?

  init(prefix: String?) {
    self.prefix = prefix
  }

  private func prefixed(_ message: String) -> String {
    return [prefix, message].compactMap({ $0 }).joined(separator: " ")
  }

  func trace(_ message: String) {
    Logger.loggingService.log(level: .trace, message: prefixed(message))
  }

  func debug(_ message: String) {
    Logger.loggingService.log(level: .debug, message: prefixed(message))
  }

  func info(_ message: String) {
    Logger.loggingService.log(level: .info, message: prefixed(message))
  }

  func notice(_ message: String) {
    Logger.loggingService.log(level: .notice, message: prefixed(message))
  }

  func warning(_ message: String) {
    Logger.loggingService.log(level: .warning, message: prefixed(message))
  }

  func error(_ message: String) {
    Logger.loggingService.log(level: .error, message: prefixed(message))
  }

  func error(_ error: Error) {
    Logger.loggingService.log(level: .error, message: prefixed(error.localizedDescription))
  }

  func critical(_ message: String) {
    Logger.loggingService.log(level: .critical, message: prefixed(message))
  }

}
