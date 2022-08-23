//
//  LogCollectable.swift
//  
//
//  Created by Vladislav Fitc on 23/08/2022.
//

import Foundation
import Logging

public protocol LogCollectable {
  static var logger: Logging.Logger { get }
}

public extension LogCollectable {

  static func trace(_ message: String) {
    logger.log(level: .trace, "\(message)")
  }

  static func debug(_ message: String) {
    logger.log(level: .debug, "\(message)")
  }

  static func info(_ message: String) {
    logger.log(level: .info, "\(message)")
  }

  static func notice(_ message: String) {
    logger.log(level: .notice, "\(message)")
  }

  static func warning(_ message: String) {
    logger.log(level: .warning, "\(message)")
  }

  static func error(_ message: String) {
    logger.log(level: .error, "\(message)")
  }

  static func critical(_ message: String) {
    logger.log(level: .critical, "\(message)")
  }

}
