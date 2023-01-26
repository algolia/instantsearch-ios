//
//  TimerControllerTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 16/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

@testable import InstantSearchInsights
import XCTest

class TimerControllerTests: XCTestCase {
  func testInit() {
    let timerController = TimerController(delay: 10)
    XCTAssertEqual(timerController.delay, 10)
    XCTAssertFalse(timerController.isActive)
    XCTAssertNil(timerController.action)
  }

  func testInvalidation() {
    let timerController = TimerController(delay: 5)
    timerController.setup()
    XCTAssertTrue(timerController.isActive)
    timerController.invalidate()
    XCTAssertFalse(timerController.isActive)
  }

  func testChangeDelay() {
    let timerController = TimerController(delay: 1)
    XCTAssertFalse(timerController.isActive)
    timerController.delay = 2
    XCTAssertEqual(timerController.delay, 2)
    XCTAssertFalse(timerController.isActive)
    timerController.setup()
    timerController.delay = 3
    XCTAssertEqual(timerController.delay, 3)
    XCTAssertTrue(timerController.isActive)
  }

  func testAction() {
    let exp = XCTestExpectation(description: "timer action")
    let timerController = TimerController(delay: 1)
    XCTAssertFalse(timerController.isActive)
    timerController.setup()
    timerController.action = {
      exp.fulfill()
    }
    timerController.fire()
    wait(for: [exp], timeout: 5)
  }
}
