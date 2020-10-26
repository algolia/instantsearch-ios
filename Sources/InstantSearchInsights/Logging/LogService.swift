//
//  LogService.swift
//  
//
//  Created by Vladislav Fitc on 23/10/2020.
//

import Foundation

public protocol LogService {

  var minLogSeverityLevel: LogLevel { get set }

  func log(level: LogLevel, message: String)

}

public extension LogService {

  func trace(_ message: String) { log(level: .trace, message: message) }
  func debug(_ message: String) { log(level: .debug, message: message) }
  func info(_ message: String) { log(level: .info, message: message) }
  func notice(_ message: String) { log(level: .notice, message: message) }
  func warning(_ message: String) { log(level: .warning, message: message) }
  func error(_ message: String) { log(level: .error, message: message) }
  func critical(_ message: String) { log(level: .critical, message: message) }

}
