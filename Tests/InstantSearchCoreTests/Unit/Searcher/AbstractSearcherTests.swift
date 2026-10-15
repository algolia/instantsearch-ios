//
//  AbstractSearcherTests.swift
//  InstantSearchCore
//

import AlgoliaCore
import Foundation
@testable import InstantSearchCore
import XCTest

/// Search service which lets the test control when and from which thread the search completions are invoked
private final class TestSearchService: SearchService {
  struct Request {
    var id: Int
  }

  typealias Result = String
  typealias Process = Operation

  private let lock = NSLock()
  private var pendingCompletions: [(Swift.Result<String, Error>) -> Void] = []

  func search(_: Request, completion: @escaping (Swift.Result<String, Error>) -> Void) -> Operation {
    let operation = BlockOperation {}
    lock.lock()
    defer { lock.unlock() }
    pendingCompletions.append { result in
      completion(result)
      // As the actual services, the operation finishes once the completion has been invoked
      operation.start()
    }
    return operation
  }

  /// Removes and returns the completions of the launched searches
  func takePendingCompletions() -> [(Swift.Result<String, Error>) -> Void] {
    lock.lock()
    defer { lock.unlock() }
    let completions = pendingCompletions
    pendingCompletions.removeAll()
    return completions
  }
}

/// Tracks the maximum number of simultaneous executions of a block
private final class ConcurrencyTracker {
  private let lock = NSLock()
  private var current = 0
  private(set) var maximum = 0

  func enter() {
    lock.lock()
    current += 1
    maximum = max(maximum, current)
    lock.unlock()
  }

  func exit() {
    lock.lock()
    current -= 1
    lock.unlock()
  }
}

private struct TestError: Error {}

class AbstractSearcherTests: XCTestCase {
  private typealias Searcher = AbstractSearcher<TestSearchService>

  private func makeSearcher() -> (Searcher, TestSearchService) {
    let service = TestSearchService()
    let searcher = Searcher(service: service, initialRequest: .init(id: 0))
    return (searcher, service)
  }

  /// Regression test for https://github.com/algolia/instantsearch-ios/issues/372
  /// The search service might complete the in-flight requests simultaneously from different threads
  /// (the Algolia API client runs the requests on the Swift concurrency cooperative thread pool),
  /// the results must nevertheless be delivered serially.
  func testConcurrentCompletionsAreDeliveredSerially() {
    let (searcher, service) = makeSearcher()
    let searchesCount = 64

    let resultsExpectation = expectation(description: "results delivered")
    resultsExpectation.expectedFulfillmentCount = searchesCount
    let tracker = ConcurrencyTracker()

    searcher.onResults.subscribe(with: self) { _, _ in
      tracker.enter()
      // Widen the window during which a concurrent delivery would be observable
      usleep(200)
      tracker.exit()
      resultsExpectation.fulfill()
    }

    for _ in 0..<searchesCount {
      searcher.search()
    }
    let completions = service.takePendingCompletions()
    XCTAssertEqual(completions.count, searchesCount)

    DispatchQueue.concurrentPerform(iterations: searchesCount) { index in
      completions[index](.success("result \(index)"))
    }

    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertEqual(tracker.maximum, 1, "onResults must never be fired concurrently")
  }

  func testConcurrentFailuresAreDeliveredSerially() {
    let (searcher, service) = makeSearcher()
    let searchesCount = 64

    let errorsExpectation = expectation(description: "errors delivered")
    errorsExpectation.expectedFulfillmentCount = searchesCount
    let tracker = ConcurrencyTracker()

    searcher.onError.subscribe(with: self) { _, _ in
      tracker.enter()
      usleep(200)
      tracker.exit()
      errorsExpectation.fulfill()
    }

    for _ in 0..<searchesCount {
      searcher.search()
    }
    let completions = service.takePendingCompletions()

    DispatchQueue.concurrentPerform(iterations: searchesCount) { index in
      completions[index](.failure(TestError()))
    }

    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertEqual(tracker.maximum, 1, "onError must never be fired concurrently")
  }

  /// The loading state must be consistent with the results delivery:
  /// the end of loading must never be observed before the results which ended it
  func testLoadingStateIsDeliveredAfterResults() {
    let (searcher, service) = makeSearcher()

    let eventsLock = NSLock()
    var events: [String] = []
    func record(_ event: String) {
      eventsLock.lock()
      events.append(event)
      eventsLock.unlock()
    }

    let loadingStartedExpectation = expectation(description: "loading started")
    let loadingEndedExpectation = expectation(description: "loading ended")
    searcher.isLoading.subscribe(with: self) { _, isLoading in
      record(isLoading ? "loading" : "loaded")
      if isLoading {
        loadingStartedExpectation.fulfill()
      } else {
        loadingEndedExpectation.fulfill()
      }
    }
    searcher.onResults.subscribe(with: self) { _, _ in
      record("results")
    }

    searcher.search()
    wait(for: [loadingStartedExpectation], timeout: 2)

    service.takePendingCompletions().forEach { $0(.success("result")) }
    wait(for: [loadingEndedExpectation], timeout: 2)

    XCTAssertEqual(events, ["loading", "results", "loaded"])
  }

  func testResultsDelivery() {
    let (searcher, service) = makeSearcher()
    let resultsExpectation = expectation(description: "results delivered")

    searcher.onResults.subscribe(with: self) { _, result in
      XCTAssertEqual(result, "result")
      resultsExpectation.fulfill()
    }

    searcher.search()
    service.takePendingCompletions().forEach { $0(.success("result")) }

    waitForExpectations(timeout: 2, handler: nil)
  }

  func testErrorDelivery() {
    let (searcher, service) = makeSearcher()
    searcher.request = .init(id: 42)
    let errorExpectation = expectation(description: "error delivered")

    searcher.onError.subscribe(with: self) { _, error in
      guard let requestError = error as? Searcher.RequestError else {
        XCTFail("Unexpected error type: \(error)")
        return
      }
      XCTAssertEqual(requestError.request.id, 42)
      XCTAssertTrue(requestError.underlyingError is TestError)
      errorExpectation.fulfill()
    }

    searcher.search()
    service.takePendingCompletions().forEach { $0(.failure(TestError())) }

    waitForExpectations(timeout: 2, handler: nil)
  }

  /// Regression test for https://github.com/algolia/instantsearch-ios/issues/370
  /// The errors caused by the cancellation of a search superseded by a more recent one must not be reported
  func testCancellationErrorsAreNotReported() {
    let cancellationErrors: [Error] = [
      CancellationError(),
      URLError(.cancelled),
      AlgoliaError.requestError(URLError(.cancelled)),
      AlgoliaError.noReachableHosts(intermediateErrors: [
        AlgoliaError.requestError(URLError(.cancelled)),
        AlgoliaError.requestError(URLError(.cancelled)),
        AlgoliaError.requestError(URLError(.cancelled))
      ], exposeIntermediateErrors: false)
    ]

    let (searcher, service) = makeSearcher()

    let errorExpectation = expectation(description: "error delivered")
    errorExpectation.isInverted = true
    errorExpectation.assertForOverFulfill = false
    searcher.onError.subscribe(with: self) { _, _ in
      errorExpectation.fulfill()
    }

    let resultsExpectation = expectation(description: "results delivered")
    searcher.onResults.subscribe(with: self) { _, _ in
      resultsExpectation.fulfill()
    }

    for _ in cancellationErrors {
      searcher.search()
    }
    for (completion, error) in zip(service.takePendingCompletions(), cancellationErrors) {
      completion(.failure(error))
    }

    // A subsequent successful search is delivered as usual
    searcher.search()
    service.takePendingCompletions().forEach { $0(.success("result")) }

    waitForExpectations(timeout: 1, handler: nil)
  }
}
