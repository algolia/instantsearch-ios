//
//  LoggingTests.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 31/01/2020.
//

import Foundation
@testable import InstantSearch
import InstantSearchInsights
import Logging
import XCTest

class TestLogHandler: LogHandler {
  
  subscript(metadataKey _: String) -> Logging.Logger.Metadata.Value? {
    get {
      return nil
    }
    set(newValue) {
      
    }
  }
  
  var metadata: Logging.Logger.Metadata = [:]
  
  var logLevel: Logging.Logger.Level = .trace
  
  var handler: (Logging.Logger.Level, Logging.Logger.Message) -> Void
  let label: String
  
  init(label: String, handler: @escaping (Logging.Logger.Level, Logging.Logger.Message) -> Void) {
    self.label = label
    self.handler = handler
  }
  
  func log(level: Logging.Logger.Level,
           message: Logging.Logger.Message,
           metadata: Logging.Logger.Metadata?,
           source: String,
           file: String,
           function: String,
           line: UInt) {
    handler(level, message)
  }
  
}

class LoggingTests: XCTestCase {

  typealias LogLevel = InstantSearchInsights.LogLevel
  
  let logLevels: [LogLevel] = [.trace, .debug, .info, .notice, .warning, .error, .critical]
  
  static var defaultLogger: Logging.Logger?
  
  override class func setUp() {
    defaultLogger = InstantSearchLog.logger
  }
  
  override class func tearDown() {
    defaultLogger.flatMap { value in
      InstantSearchLog.logger = value
    }
  }
  
  func testMatchLevel() {
    
    let messages = [LogLevel: String](logLevels.map { ($0, .random()) }, uniquingKeysWith: { k, _ in k })

    let expectation = self.expectation(description: "All messages captured")
    expectation.expectedFulfillmentCount = messages.count
    
    InstantSearchLog.logger = Logger(label: "test insights logger", factory: { label in
      return TestLogHandler(label: label) { level, message in
        XCTAssertEqual("\(message)", messages[LogLevel(swiftLogLevel: level)])
        expectation.fulfill()
      }
    })
    
    for (level, message) in messages {
      InstantSearchLog.logger.log(level: level.swiftLogLevel, "\(message)")
    }
    
    waitForExpectations(timeout: 5, handler: nil)

  }
  
  func testSetLogSeverityLevel() {
    
    let logLevels = Array(self.logLevels.reversed())
    
    // Ensure that logs with level < logSeverityLevel not captured
    for (index, logLevel) in logLevels.enumerated() {
      
      let exp = expectation(description: "unexpected log for \(logLevel)")
      exp.isInverted = true
      
      InstantSearchLog.logger = Logger(label: "test insights logger", factory: { label in
        return TestLogHandler(label: label) { level, message in
          exp.fulfill()
        }
      })
      
      Logs.logSeverityLevel = logLevel
      
      for nextLogLevel in logLevels.dropFirst(index+1) {
        InstantSearchLog.logger.log(level: nextLogLevel.swiftLogLevel, "test")
      }
    }
    waitForExpectations(timeout: 5, handler: nil)
        
    // Ensure that logs with level > logSeverityLevel captured
    for (index, logLevel) in logLevels.enumerated() {
      
      let exp = expectation(description: "expected log for \(logLevel)")
      exp.expectedFulfillmentCount = index + 1
      
      InstantSearchLog.logger = Logger(label: "test insights logger", factory: { label in
        return TestLogHandler(label: label) { level, message in
          exp.fulfill()
        }
      })
      
      Logs.logSeverityLevel = logLevel
      
      guard index != 0 else {
        InstantSearchLog.logger.log(level: logLevels[0].swiftLogLevel, "test")
        continue
      }
      for nextLogLevel in logLevels[0...index] {
        InstantSearchLog.logger.log(level: nextLogLevel.swiftLogLevel, "test")
      }
    }
    waitForExpectations(timeout: 2, handler: nil)
    
  }
  
}
