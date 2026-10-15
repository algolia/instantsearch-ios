//
//  SignalTests.swift
//  InstantSearchCore
//

import Foundation
@testable import InstantSearchCore
import XCTest

class SignalTests: XCTestCase {
  private final class Observer {}

  // MARK: - Thread safety

  /// Regression test for https://github.com/algolia/instantsearch-ios/issues/372
  /// Concurrent fires, subscriptions and cancellations must not corrupt the signal state nor crash
  func testConcurrentFireSubscribeAndCancel() {
    let signal = Signal<Int>(retainLastData: true)
    let observers = (0..<8).map { _ in Observer() }
    let iterations = 20000

    let callbacksCount = Counter()

    DispatchQueue.concurrentPerform(iterations: iterations) { iteration in
      let observer = observers[iteration % observers.count]
      switch iteration % 5 {
      case 0:
        signal.fire(iteration)
      case 1:
        signal.subscribe(with: observer) { _, _ in callbacksCount.increment() }
      case 2:
        signal.cancelSubscription(for: observer)
      case 3:
        signal.subscribePast(with: observer) { _, _ in callbacksCount.increment() }
      default:
        _ = signal.lastDataFired
        _ = signal.observers
        _ = signal.fireCount
      }
    }

    XCTAssertEqual(signal.fireCount, iterations / 5)
    XCTAssertNotNil(signal.lastDataFired)
    withExtendedLifetime(observers) {}
  }

  /// A one-shot subscription must be delivered exactly once even when the signal is fired concurrently
  func testSubscribeOnceDeliversOnceUnderConcurrentFires() {
    let signal = Signal<Int>()
    let observer = Observer()
    let callbacksCount = Counter()

    signal.subscribeOnce(with: observer) { _, _ in callbacksCount.increment() }

    DispatchQueue.concurrentPerform(iterations: 1000) { iteration in
      signal.fire(iteration)
    }

    XCTAssertEqual(callbacksCount.value, 1)
    withExtendedLifetime(observer) {}
  }

  // MARK: - Re-entrancy

  func testSubscribingFromCallbackDoesNotDeadlock() {
    let signal = Signal<Int>()
    let observer = Observer()
    let nestedObserver = Observer()
    let nestedCallbackExpectation = expectation(description: "nested callback")

    signal.subscribe(with: observer) { _, _ in
      signal.subscribe(with: nestedObserver) { _, _ in
        nestedCallbackExpectation.fulfill()
      }
      signal.cancelSubscription(for: observer)
    }

    signal.fire(1)
    signal.fire(2)

    waitForExpectations(timeout: 1, handler: nil)
    XCTAssertEqual(signal.observers.count, 1)
    XCTAssertTrue(signal.observers.first === nestedObserver)
    withExtendedLifetime((observer, nestedObserver)) {}
  }

  func testFiringFromCallbackDoesNotDeadlock() {
    let signal = Signal<Int>()
    let observer = Observer()
    var receivedValues: [Int] = []

    signal.subscribe(with: observer) { _, value in
      receivedValues.append(value)
      if value < 3 {
        signal.fire(value + 1)
      }
    }

    signal.fire(1)

    XCTAssertEqual(receivedValues, [1, 2, 3])
    withExtendedLifetime(observer) {}
  }

  // MARK: - Semantics

  func testSubscribeOnce() {
    let signal = Signal<Int>()
    let observer = Observer()
    var receivedValues: [Int] = []

    signal.subscribeOnce(with: observer) { _, value in
      receivedValues.append(value)
    }

    signal.fire(1)
    signal.fire(2)

    XCTAssertEqual(receivedValues, [1])
    XCTAssertTrue(signal.observers.isEmpty)
    withExtendedLifetime(observer) {}
  }

  func testSubscribePastReplaysLastDataAndKeepsListening() {
    let signal = Signal<Int>(retainLastData: true)
    let observer = Observer()
    var receivedValues: [Int] = []

    signal.fire(1)
    signal.subscribePast(with: observer) { _, value in
      receivedValues.append(value)
    }
    signal.fire(2)

    XCTAssertEqual(receivedValues, [1, 2])
    XCTAssertEqual(signal.observers.count, 1)
    withExtendedLifetime(observer) {}
  }

  func testSubscribePastOnceReplaysLastDataWithoutRegistering() {
    let signal = Signal<Int>(retainLastData: true)
    let observer = Observer()
    var receivedValues: [Int] = []

    signal.fire(1)
    signal.subscribePastOnce(with: observer) { _, value in
      receivedValues.append(value)
    }
    signal.fire(2)

    XCTAssertEqual(receivedValues, [1])
    XCTAssertTrue(signal.observers.isEmpty)
    withExtendedLifetime(observer) {}
  }

  func testSubscribePastOnceWithoutPastDataDeliversNextFireOnce() {
    let signal = Signal<Int>(retainLastData: true)
    let observer = Observer()
    var receivedValues: [Int] = []

    signal.subscribePastOnce(with: observer) { _, value in
      receivedValues.append(value)
    }
    signal.fire(1)
    signal.fire(2)

    XCTAssertEqual(receivedValues, [1])
    XCTAssertTrue(signal.observers.isEmpty)
    withExtendedLifetime(observer) {}
  }

  func testRetainLastData() {
    let signal = Signal<Int>(retainLastData: true)
    signal.fire(1)
    XCTAssertEqual(signal.lastDataFired, 1)
    XCTAssertEqual(signal.fireCount, 1)

    signal.clearLastData()
    XCTAssertNil(signal.lastDataFired)

    signal.fire(2)
    XCTAssertEqual(signal.lastDataFired, 2)
    signal.retainLastData = false
    XCTAssertNil(signal.lastDataFired)
    XCTAssertEqual(signal.fireCount, 2)
  }

  func testCancelSubscriptions() {
    let signal = Signal<Int>()
    let observer1 = Observer()
    let observer2 = Observer()
    let callbacksCount = Counter()

    signal.subscribe(with: observer1) { _, _ in callbacksCount.increment() }
    signal.subscribe(with: observer2) { _, _ in callbacksCount.increment() }
    signal.fire(1)
    XCTAssertEqual(callbacksCount.value, 2)

    signal.cancelSubscription(for: observer1)
    signal.fire(2)
    XCTAssertEqual(callbacksCount.value, 3)
    XCTAssertEqual(signal.observers.count, 1)

    signal.cancelAllSubscriptions()
    signal.fire(3)
    XCTAssertEqual(callbacksCount.value, 3)
    XCTAssertTrue(signal.observers.isEmpty)
    withExtendedLifetime((observer1, observer2)) {}
  }

  func testDeallocatedObserverIsFlushed() {
    let signal = Signal<Int>()
    var observer: Observer? = Observer()
    let callbacksCount = Counter()

    signal.subscribe(with: observer!) { _, _ in callbacksCount.increment() }
    XCTAssertEqual(signal.observers.count, 1)

    observer = nil
    signal.fire(1)

    XCTAssertEqual(callbacksCount.value, 0)
    XCTAssertTrue(signal.observers.isEmpty)
  }
}

/// Thread-safe counter
final class Counter {
  private let lock = NSLock()
  private var _value = 0

  var value: Int {
    lock.lock()
    defer { lock.unlock() }
    return _value
  }

  func increment() {
    lock.lock()
    defer { lock.unlock() }
    _value += 1
  }
}
