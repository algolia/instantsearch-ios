//
//  LogTest.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 31/01/2020.
//

@testable import InstantSearch
import InstantSearchCore
import Foundation
import XCTest
import Logging

extension XCTestCase {
  
  class TestLoggingService: Loggable {
    
    var minSeverityLevel: LogLevel = .trace
  
    var closure: (LogLevel, String) -> Void
    
    init(_ closure: @escaping (LogLevel, String) -> Void) {
      self.closure = closure
    }
    
    func log(level: LogLevel, message: String) {
      closure(level, message)
    }
    
  }
  
  func expectLog(expectedMessage: String, expectedLevel: LogLevel, testcase: @escaping () -> Void) {
    
    let expectation = self.expectation(description: "expectingLog")
    
    Logger.loggingService = TestLoggingService { level, message in
      XCTAssertEqual(level, expectedLevel)
      XCTAssertEqual(message, expectedMessage)
      expectation.fulfill()
    }
    
    testcase()
    
    waitForExpectations(timeout: 10) { _ in
      Logger.loggingService = Logging.Logger(label: "com.algolia.InstantSearch")
    }
    

    
  }
  
}
