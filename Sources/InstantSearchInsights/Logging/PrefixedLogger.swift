//
//  PrefixedLogger.swift
//  
//
//  Created by Vladislav Fitc on 22/10/2020.
//

import Foundation

struct PrefixedLogger {

  let prefix: String?

  init(prefix: String?) {
    self.prefix = prefix
  }

  private func prefixed(_ message: String) -> String {
    return [prefix, message].compactMap({ $0 }).joined(separator: " ")
  }

  func trace(_ message: String) {
    Logger.InstantSearchInsights.log(level: .trace, message: prefixed(message))
  }

  func debug(_ message: String) {
    Logger.InstantSearchInsights.log(level: .debug, message: prefixed(message))
  }

  func info(_ message: String) {
    Logger.InstantSearchInsights.log(level: .info, message: prefixed(message))
  }

  func notice(_ message: String) {
    Logger.InstantSearchInsights.log(level: .notice, message: prefixed(message))
  }

  func warning(_ message: String) {
    Logger.InstantSearchInsights.log(level: .warning, message: prefixed(message))
  }

  func error(_ message: String) {
    Logger.InstantSearchInsights.log(level: .error, message: prefixed(message))
  }

  func error(_ error: Error) {
    Logger.InstantSearchInsights.log(level: .error, message: prefixed(error.localizedDescription))
  }

  func critical(_ message: String) {
    Logger.InstantSearchInsights.log(level: .critical, message: prefixed(message))
  }

}
