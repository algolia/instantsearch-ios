//
//  LoggingTests.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 31/01/2020.
//

@testable import InstantSearch
import InstantSearchInsights
import Foundation
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
    
    Logger.InstantSearch.service = service
    
    for (level, message) in messages {
      Logger.InstantSearch.log(level: level, message: message)
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
    
    Logger.InstantSearch.service = service
    Logger.InstantSearch.isEnabled = false
    
    for (level, message) in messages {
      Logger.InstantSearch.log(level: level, message: message)
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testSetMinSeverityLevel() {
    
    let logLevels: [LogLevel] = [.trace, .debug, .info, .notice, .warning, .error, .critical]
    let loggingService = TestLoggingService { _, _ in }
    Logger.InstantSearch.service = loggingService
    for level in logLevels {
      Logger.InstantSearch.minLogSeverityLevel = level
      XCTAssertEqual(loggingService.minLogSeverityLevel, level)
    }
  }
    
}
