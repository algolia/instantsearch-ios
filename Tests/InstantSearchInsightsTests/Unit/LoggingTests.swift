//
//  LoggingTests.swift
//  
//
//  Created by Vladislav Fitc on 22/10/2020.
//

import Foundation
@testable import InstantSearchInsights
import XCTest

class LoggingTests: XCTestCase {

  typealias LogLevel = InstantSearchInsights.LogLevel
  
  class TestLoggingService: LogService {
    
    var minLogSeverityLevel: LogLevel = .trace
    
    var closure: (LogLevel, String) -> Void

    init(_ closure: @escaping (LogLevel, String) -> Void) {
      self.closure = closure
    }

    func log(level: LogLevel, message: String) {
      closure(level, message)
    }

  }
  
  func testMatchLevel() {
    
    let logLevels: [LogLevel] = [.trace, .debug, .info, .notice, .warning, .error, .critical]
    
    let messages = [LogLevel: String](logLevels.map { ($0, .random()) }, uniquingKeysWith: { k, _ in k })
    
    let expectation = self.expectation(description: "All messages captured")
    expectation.expectedFulfillmentCount = messages.count
    
    let service = TestLoggingService { (level, message) in
      XCTAssertEqual(message, messages[level])
      expectation.fulfill()
    }
    
    Logger.InstantSearchInsights.service = service
    
    for (level, message) in messages {
      Logger.InstantSearchInsights.log(level: level, message: message)
    }
    
    waitForExpectations(timeout: 5, handler: nil)

  }
  
  func testMute() {
    
    let logLevels: [LogLevel] = [.trace, .debug, .info, .notice, .warning, .error, .critical]
    
    let messages = [LogLevel: String](logLevels.map { ($0, .random()) }, uniquingKeysWith: { k, _ in k })
    
    let expectation = self.expectation(description: "No message captured")
    expectation.isInverted = true

    let service = TestLoggingService { (level, message) in
      expectation.fulfill()
    }
    
    Logger.InstantSearchInsights.service = service
    Logger.InstantSearchInsights.isEnabled = false
    
    for (level, message) in messages {
      Logger.InstantSearchInsights.log(level: level, message: message)
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testSetMinSeverityLevel() {
    
    let logLevels: [LogLevel] = [.trace, .debug, .info, .notice, .warning, .error, .critical]
    let loggingService = TestLoggingService { _, _ in }
    Logger.InstantSearchInsights.service = loggingService
    for level in logLevels {
      Logger.InstantSearchInsights.minLogSeverityLevel = level
      XCTAssertEqual(loggingService.minLogSeverityLevel, level)
    }
  }
    
}
