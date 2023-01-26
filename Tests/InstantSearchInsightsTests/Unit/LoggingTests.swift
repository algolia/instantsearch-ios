//
//  LoggingTests.swift
//
//
//  Created by Vladislav Fitc on 22/10/2020.
//

import Foundation
@testable import InstantSearchInsights
import Logging
import XCTest

class TestLogHandler: LogHandler {
  subscript(metadataKey _: String) -> Logger.Metadata.Value? {
    get {
      return nil
    }
    set(newValue) {}
  }

  var metadata: Logger.Metadata = [:]

  var logLevel: Logger.Level = .trace

  var handler: (Logger.Level, Logger.Message) -> Void
  let label: String

  init(label: String, handler: @escaping (Logger.Level, Logger.Message) -> Void) {
    self.label = label
    self.handler = handler
  }

  func log(level: Logger.Level,
           message: Logger.Message,
           metadata _: Logger.Metadata?,
           source _: String,
           file _: String,
           function _: String,
           line _: UInt) {
    handler(level, message)
  }
}

class LoggingTests: XCTestCase {
  let logLevels: [LogLevel] = [.trace, .debug, .info, .notice, .warning, .error, .critical]

  static var defaultLogger: Logging.Logger?

  override class func setUp() {
    defaultLogger = InstantSearchInsightsLog.logger
  }

  override class func tearDown() {
    defaultLogger.flatMap { value in
      InstantSearchInsightsLog.logger = value
    }
  }

  func testMatchLevel() {
    let messages = [LogLevel: String](logLevels.map { ($0, .random()) }, uniquingKeysWith: { k, _ in k })

    let expectation = self.expectation(description: "All messages captured")
    expectation.expectedFulfillmentCount = messages.count

    InstantSearchInsightsLog.logger = Logger(label: "test insights logger", factory: { label in
      return TestLogHandler(label: label) { level, message in
        XCTAssertEqual("\(message)", messages[LogLevel(swiftLogLevel: level)])
        expectation.fulfill()
      }
    })

    for (level, message) in messages {
      InstantSearchInsightsLog.logger.log(level: level.swiftLogLevel, "\(message)")
    }

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testSetLogSeverityLevel() {
    let logLevels = Array(self.logLevels.reversed())

    // Ensure that logs with level < logSeverityLevel not captured
    for (index, logLevel) in logLevels.enumerated() {
      let exp = expectation(description: "unexpected log for \(logLevel)")
      exp.isInverted = true

      InstantSearchInsightsLog.logger = Logger(label: "test insights logger", factory: { label in
        return TestLogHandler(label: label) { _, _ in
          exp.fulfill()
        }
      })

      Logs.logSeverityLevel = logLevel

      for nextLogLevel in logLevels.dropFirst(index + 1) {
        InstantSearchInsightsLog.logger.log(level: nextLogLevel.swiftLogLevel, "test")
      }
    }
    waitForExpectations(timeout: 5, handler: nil)

    // Ensure that logs with level > logSeverityLevel captured
    for (index, logLevel) in logLevels.enumerated() {
      let exp = expectation(description: "expected log for \(logLevel)")
      exp.expectedFulfillmentCount = index + 1

      InstantSearchInsightsLog.logger = Logger(label: "test insights logger", factory: { label in
        return TestLogHandler(label: label) { _, _ in
          exp.fulfill()
        }
      })

      Logs.logSeverityLevel = logLevel

      guard index != 0 else {
        InstantSearchInsightsLog.logger.log(level: logLevels[0].swiftLogLevel, "test")
        continue
      }
      for nextLogLevel in logLevels[0...index] {
        InstantSearchInsightsLog.logger.log(level: nextLogLevel.swiftLogLevel, "test")
      }
    }
    waitForExpectations(timeout: 2, handler: nil)
  }
}
