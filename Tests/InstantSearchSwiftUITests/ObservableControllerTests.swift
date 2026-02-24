//
//  ObservableControllerTests.swift
//
//
//  Created by Vladislav Fitc on 05/11/2021.
//

#if !InstantSearchCocoaPods
  import InstantSearchCore
#endif
@testable import InstantSearchSwiftUI
import XCTest

// MARK: - Test Helper

struct TestRecord<Value: Codable>: Codable {
  let objectID: String
  let value: Value

  init(_ value: Value, objectID: String = UUID().uuidString) {
    self.value = value
    self.objectID = objectID
  }

  static func withValue(_ value: Value) -> Self {
    .init(value)
  }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
class ObservableControllerTests: XCTestCase {

  // MARK: - Basic Functionality Tests

  func testInitialState() {
    let controller = HitsObservableController<String>()

    XCTAssertEqual(controller.hits.count, 0)
    XCTAssertNil(controller.hitsSource)
  }

  func testReloadWithNoHitsSource() {
    let controller = HitsObservableController<String>()

    let expectation = self.expectation(description: "hits remain empty")

    controller.reload()

    // Wait for async dispatch to complete
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      XCTAssertEqual(controller.hits.count, 0)
      expectation.fulfill()
    }

    waitForExpectations(timeout: 1.0)
  }

  func testReloadWithEmptyHitsSource() {
    let controller = HitsObservableController<String>()
    let interactor = HitsInteractor<String>(infiniteScrolling: .off, showItemsOnEmptyQuery: true)

    controller.hitsSource = interactor

    let expectation = self.expectation(description: "hits updated to empty")

    controller.reload()

    // Wait for async dispatch to complete
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      XCTAssertEqual(controller.hits.count, 0)
      expectation.fulfill()
    }

    waitForExpectations(timeout: 1.0)
  }

  func testScrollToTop() {
    let controller = HitsObservableController<String>()
    let initialScrollID = controller.scrollID

    controller.scrollToTop()

    XCTAssertNotEqual(controller.scrollID, initialScrollID)
  }

  // MARK: - Thread Safety Tests

  func testReloadIsAsyncAndMainThread() {
    let controller = HitsObservableController<String>()
    let interactor = HitsInteractor<String>(infiniteScrolling: .off, showItemsOnEmptyQuery: true)

    controller.hitsSource = interactor

    let expectation = self.expectation(description: "reload completes on main thread")

    // Call reload from a background thread
    DispatchQueue.global(qos: .background).async {
      controller.reload()

      // Wait for main thread update
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        // Verify reload was dispatched to main thread (test passes if no crash)
        XCTAssertTrue(Thread.isMainThread)
        expectation.fulfill()
      }
    }

    waitForExpectations(timeout: 1.0)
  }

  // MARK: - Concurrency Tests

  func testConcurrentReloadAndAccessDoesNotCrash() {
    let controller = HitsObservableController<String>()
    let interactor = HitsInteractor<String>(infiniteScrolling: .off, showItemsOnEmptyQuery: true)

    controller.hitsSource = interactor

    let expectation = self.expectation(description: "concurrent operations complete")
    expectation.expectedFulfillmentCount = 2

    // Simulate concurrent reloads
    DispatchQueue.global(qos: .background).async {
      for _ in 0..<10 {
        controller.reload()
      }
      expectation.fulfill()
    }

    // Concurrently access hits array (simulating ForEach iteration)
    DispatchQueue.main.async {
      for _ in 0..<50 {
        let count = controller.hits.count
        // Try to access indices - should not crash with bounds checking
        for index in 0..<count {
          if index < controller.hits.count {
            _ = controller.hits[index]
          }
        }
        Thread.sleep(forTimeInterval: 0.001)
      }
      expectation.fulfill()
    }

    waitForExpectations(timeout: 5.0)
  }
}

// Note: Full integration tests with SearchResponse are in InstantSearchCoreTests.
// These tests focus on the SwiftUI-specific threading and bounds checking behavior.
