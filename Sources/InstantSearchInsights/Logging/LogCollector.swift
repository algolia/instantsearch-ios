//
//  LogCollector.swift
//  
//
//  Created by Vladislav Fitc on 22/10/2020.
//

import Foundation

public protocol LogCollector {

  static func log(level: LogLevel, message: String)

}

public extension LogCollector {

  static func trace(_ message: String) { log(level: .trace, message: message) }
  static func debug(_ message: String) { log(level: .debug, message: message) }
  static func info(_ message: String) { log(level: .info, message: message) }
  static func notice(_ message: String) { log(level: .notice, message: message) }
  static func warning(_ message: String) { log(level: .warning, message: message) }
  static func error(_ message: String) { log(level: .error, message: message) }
  static func critical(_ message: String) { log(level: .critical, message: message) }

}
