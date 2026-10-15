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

  /// The subscription configuration is typically chained right after the subscription, while the signal might
  /// already be firing from another thread
  func testConcurrentConfigurationAndCancellation() {
    let signal = Signal<Int>(retainLastData: true)
    let observers = (0..<8).map { _ in Observer() }
    let queue = DispatchQueue(label: "SignalTests.delivery")
    let callbacksCount = Counter()
    let subscriptions = SubscriptionsBag<Int>()
    let iterations = 3000

    DispatchQueue.concurrentPerform(iterations: iterations) { iteration in
      let observer = observers[iteration % observers.count]
      switch iteration % 6 {
      case 0:
        signal.fire(iteration)
      case 1:
        let subscription = signal.subscribe(with: observer) { _, _ in callbacksCount.increment() }
          .filter { $0 % 2 == 0 }
          .onQueue(queue)
        subscriptions.add(subscription)
      case 2:
        let subscription = signal.subscribePast(with: observer) { _, _ in callbacksCount.increment() }
          .sample(every: 0.001)
        subscriptions.add(subscription)
      case 3:
        let subscription = signal.subscribe(with: observer) { _, _ in callbacksCount.increment() }
        subscription.once = true
        subscriptions.add(subscription)
      case 4:
        subscriptions.cancelRandom()
      default:
        _ = subscriptions.observers
        signal.cancelSubscription(for: observer)
      }
    }

    XCTAssertEqual(signal.fireCount, iterations / 6)
    withExtendedLifetime(observers) {}
  }

  // MARK: - Replay ordering

  /// Regression test: the data fired while the past data is being replayed to a `subscribePast` observer must be
  /// delivered after the replay, in order
  func testFiresDuringReplayAreDeliveredAfterIt() {
    let signal = Signal<Int>(retainLastData: true)
    signal.fire(0)

    let recorder = ValuesRecorder()
    let replayStarted = DispatchSemaphore(value: 0)
    let replayMayComplete = DispatchSemaphore(value: 0)
    let subscribedExpectation = expectation(description: "subscribed")

    DispatchQueue.global().async {
      signal.subscribePast(with: recorder) { recorder, value in
        if value == 0 {
          // Replay of the past data: block until the test fired more recent data
          replayStarted.signal()
          replayMayComplete.wait()
        }
        recorder.record(value)
      }
      subscribedExpectation.fulfill()
    }

    replayStarted.wait()
    signal.fire(1)
    signal.fire(2)
    replayMayComplete.signal()
    wait(for: [subscribedExpectation], timeout: 5)

    XCTAssertEqual(recorder.values, [0, 1, 2])
  }

  /// Regression test: a `subscribePast` observer must never receive the replayed past data after a more recent one
  /// delivered by a concurrent fire
  func testReplayIsNotOvertakenByConcurrentFires() {
    let signal = Signal<Int>(retainLastData: true)
    signal.fire(0)

    let recorders = (0..<500).map { _ in MonotonicRecorder() }
    let firingQueue = DispatchQueue(label: "SignalTests.firing")
    let shouldStopFiring = AtomicFlag()
    let firingStopped = expectation(description: "firing stopped")

    firingQueue.async {
      var value = 1
      while !shouldStopFiring.isSet {
        signal.fire(value)
        value += 1
      }
      firingStopped.fulfill()
    }

    for recorder in recorders {
      signal.subscribePast(with: recorder) { recorder, value in
        recorder.record(value)
      }
    }

    shouldStopFiring.set()
    wait(for: [firingStopped], timeout: 10)

    for recorder in recorders {
      XCTAssertTrue(recorder.didReceiveValue, "The past data must be replayed")
      XCTAssertFalse(recorder.didReceiveOutOfOrderValue, "The replayed past data must not be delivered after a more recent one")
    }
  }

  // MARK: - Re-entrancy

  /// Regression test: the deinitializer of the data displaced by a fire might re-enter the signal
  func testPayloadDeinitReenteringSignalDoesNotDeadlock() {
    let signal = Signal<ReenteringPayload>(retainLastData: true)
    let observer = Observer()
    signal.subscribe(with: observer) { _, _ in }

    let didComplete = assertCompletes("payload deinit re-entering the signal") {
      signal.fire(ReenteringPayload { signal.cancelAllSubscriptions() })
      // Displaces the previous payload, which cancels the subscriptions from its deinit
      signal.fire(ReenteringPayload { signal.fire(ReenteringPayload {}) })
      // Displaces the current payload, which fires the signal from its deinit
      signal.clearLastData()
      signal.fire(ReenteringPayload { _ = signal.lastDataFired; _ = signal.observers })
      // Displaces the current payload, which reads the signal state from its deinit
      signal.retainLastData = false
    }
    guard didComplete else { return }
    XCTAssertNil(signal.lastDataFired)
    XCTAssertTrue(signal.observers.isEmpty)
    withExtendedLifetime(observer) {}
  }

  /// Regression test: the deinitializer of an object captured by a removed subscription might re-enter the signal
  func testSubscriptionCaptureDeinitReenteringSignalDoesNotDeadlock() {
    let signal = Signal<Int>(retainLastData: true)
    let observer = Observer()
    let otherObserver = Observer()
    var temporaryObserver: Observer? = Observer()

    // Each subscription callback captures an object which is only retained by the callback and re-enters the signal
    // from its deinit once the subscription is removed
    func subscribeWithReenteringCapture(_ observer: Observer) {
      let capture = ReenteringPayload {
        signal.fire(1)
        signal.cancelSubscription(for: otherObserver)
        signal.clearLastData()
        _ = signal.observers
      }
      signal.subscribe(with: observer) { [capture] _, _ in _ = capture }
    }
    subscribeWithReenteringCapture(temporaryObserver!)
    subscribeWithReenteringCapture(observer)
    subscribeWithReenteringCapture(otherObserver)

    let didComplete = assertCompletes("subscription capture deinit re-entering the signal") {
      // The subscription of the deallocated observer is flushed by the fire, releasing its capture
      temporaryObserver = nil
      signal.fire(0)
      // The subscription is removed, releasing its capture
      signal.cancelSubscription(for: observer)
      // The remaining subscriptions are removed, releasing their captures
      signal.cancelAllSubscriptions()
    }
    guard didComplete else { return }
    XCTAssertTrue(signal.observers.isEmpty)
    XCTAssertNil(signal.lastDataFired)
    withExtendedLifetime((observer, otherObserver)) {}
  }

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

  func testCancelViaSubscription() {
    let signal = Signal<Int>()
    let observer = Observer()
    let callbacksCount = Counter()

    let subscription = signal.subscribe(with: observer) { _, _ in callbacksCount.increment() }
    signal.fire(1)
    subscription.cancel()
    signal.fire(2)

    XCTAssertEqual(callbacksCount.value, 1)
    XCTAssertNil(subscription.observer)
    XCTAssertTrue(signal.observers.isEmpty)
    withExtendedLifetime(observer) {}
  }

  func testFilter() {
    let signal = Signal<Int>()
    let observer = Observer()
    var receivedValues: [Int] = []
    var receivedOnceValues: [Int] = []

    signal.subscribe(with: observer) { _, value in
      receivedValues.append(value)
    }.filter { $0.isMultiple(of: 2) }
    // A filtered out value must not consume a one-shot subscription
    signal.subscribeOnce(with: observer) { _, value in
      receivedOnceValues.append(value)
    }.filter { $0 > 3 }

    (1...6).forEach(signal.fire)

    XCTAssertEqual(receivedValues, [2, 4, 6])
    XCTAssertEqual(receivedOnceValues, [4])
    withExtendedLifetime(observer) {}
  }

  func testOnQueue() {
    let signal = Signal<Int>()
    let observer = Observer()
    let queue = DispatchQueue(label: "SignalTests.onQueue")
    let queueKey = DispatchSpecificKey<Bool>()
    queue.setSpecific(key: queueKey, value: true)
    let deliveryExpectation = expectation(description: "delivered on the queue")

    signal.subscribe(with: observer) { _, value in
      XCTAssertEqual(DispatchQueue.getSpecific(key: queueKey), true)
      XCTAssertEqual(value, 1)
      deliveryExpectation.fulfill()
    }.onQueue(queue)

    signal.fire(1)

    waitForExpectations(timeout: 1, handler: nil)
    withExtendedLifetime(observer) {}
  }

  func testSample() {
    let signal = Signal<Int>()
    let observer = Observer()
    var receivedValues: [Int] = []
    let deliveryExpectation = expectation(description: "sampled data delivered")

    signal.subscribe(with: observer) { _, value in
      receivedValues.append(value)
      deliveryExpectation.fulfill()
    }.sample(every: 0.05)

    signal.fire(1)
    signal.fire(2)
    signal.fire(3)

    waitForExpectations(timeout: 1, handler: nil)
    XCTAssertEqual(receivedValues, [3], "Only the latest data of the sampling interval must be delivered")
    withExtendedLifetime(observer) {}
  }

  // MARK: - Helpers

  /// Runs the block on a background thread and fails if it doesn't complete in time, which denotes a deadlock.
  ///
  /// - returns: whether the block completed. The caller must not touch the signal otherwise, as its lock is stuck.
  private func assertCompletes(_ description: String,
                               timeout: TimeInterval = 5,
                               file: StaticString = #filePath,
                               line: UInt = #line,
                               _ block: @escaping () -> Void) -> Bool {
    let completionExpectation = XCTestExpectation(description: description)
    DispatchQueue.global().async {
      block()
      completionExpectation.fulfill()
    }
    let result = XCTWaiter().wait(for: [completionExpectation], timeout: timeout)
    XCTAssertEqual(result, .completed, "\(description) deadlocked", file: file, line: line)
    return result == .completed
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

/// Thread-safe flag
final class AtomicFlag {
  private let lock = NSLock()
  private var _isSet = false

  var isSet: Bool {
    lock.lock()
    defer { lock.unlock() }
    return _isSet
  }

  func set() {
    lock.lock()
    defer { lock.unlock() }
    _isSet = true
  }
}

/// Thread-safe collection of subscriptions
final class SubscriptionsBag<T> {
  private let lock = NSLock()
  private var subscriptions: [SignalSubscription<T>] = []

  var observers: [AnyObject] {
    lock.lock()
    defer { lock.unlock() }
    return subscriptions.compactMap { $0.observer }
  }

  func add(_ subscription: SignalSubscription<T>) {
    lock.lock()
    defer { lock.unlock() }
    subscriptions.append(subscription)
  }

  func cancelRandom() {
    lock.lock()
    let subscription = subscriptions.randomElement()
    lock.unlock()
    subscription?.cancel()
  }
}

/// Thread-safe recorder of the received values
final class ValuesRecorder {
  private let lock = NSLock()
  private var _values: [Int] = []

  var values: [Int] {
    lock.lock()
    defer { lock.unlock() }
    return _values
  }

  func record(_ value: Int) {
    lock.lock()
    defer { lock.unlock() }
    _values.append(value)
  }
}

/// Records whether the received values were ever out of order
final class MonotonicRecorder {
  private let lock = NSLock()
  private var lastValue: Int?
  private var _didReceiveOutOfOrderValue = false

  var didReceiveValue: Bool {
    lock.lock()
    defer { lock.unlock() }
    return lastValue != nil
  }

  var didReceiveOutOfOrderValue: Bool {
    lock.lock()
    defer { lock.unlock() }
    return _didReceiveOutOfOrderValue
  }

  func record(_ value: Int) {
    lock.lock()
    defer { lock.unlock() }
    if let lastValue = lastValue, value < lastValue {
      _didReceiveOutOfOrderValue = true
    }
    lastValue = value
  }
}

/// Object performing an arbitrary action when deallocated
final class ReenteringPayload {
  private let onDeinit: () -> Void

  init(_ onDeinit: @escaping () -> Void) {
    self.onDeinit = onDeinit
  }

  deinit {
    onDeinit()
  }
}
