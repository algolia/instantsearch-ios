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

private struct TestError: Error {}

class AbstractSearcherTests: XCTestCase {
  private typealias Searcher = AbstractSearcher<TestSearchService>

  private func makeSearcher() -> (Searcher, TestSearchService) {
    let service = TestSearchService()
    let searcher = Searcher(service: service, initialRequest: .init(id: 0))
    return (searcher, service)
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
