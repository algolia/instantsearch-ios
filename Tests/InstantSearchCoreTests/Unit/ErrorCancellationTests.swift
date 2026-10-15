//
//  ErrorCancellationTests.swift
//  InstantSearchCore
//

import AlgoliaCore
import Foundation
@testable import InstantSearchCore
import XCTest

class ErrorCancellationTests: XCTestCase {
  private struct SomeError: Error {}

  func testCancellationError() {
    XCTAssertTrue(CancellationError().isCancellation)
  }

  func testURLError() {
    XCTAssertTrue(URLError(.cancelled).isCancellation)
    XCTAssertFalse(URLError(.timedOut).isCancellation)
    XCTAssertFalse(URLError(.notConnectedToInternet).isCancellation)
  }

  func testRequestError() {
    XCTAssertTrue(AlgoliaError.requestError(URLError(.cancelled)).isCancellation)
    XCTAssertTrue(AlgoliaError.requestError(CancellationError()).isCancellation)
    XCTAssertFalse(AlgoliaError.requestError(URLError(.timedOut)).isCancellation)
    XCTAssertFalse(AlgoliaError.requestError(SomeError()).isCancellation)
  }

  func testNoReachableHosts() {
    let cancelled = AlgoliaError.requestError(URLError(.cancelled))
    let timedOut = AlgoliaError.requestError(URLError(.timedOut))

    // A cancelled task fails immediately on every host of the retry strategy
    XCTAssertTrue(AlgoliaError.noReachableHosts(intermediateErrors: [cancelled, cancelled, cancelled],
                                                exposeIntermediateErrors: false).isCancellation)
    XCTAssertTrue(AlgoliaError.noReachableHosts(intermediateErrors: [cancelled],
                                                exposeIntermediateErrors: true).isCancellation)
    // The task might be cancelled while already retrying on another host
    XCTAssertTrue(AlgoliaError.noReachableHosts(intermediateErrors: [timedOut, cancelled, cancelled],
                                                exposeIntermediateErrors: false).isCancellation)
    // Genuine network failures are not cancellations
    XCTAssertFalse(AlgoliaError.noReachableHosts(intermediateErrors: [timedOut, timedOut, timedOut],
                                                 exposeIntermediateErrors: false).isCancellation)
    XCTAssertFalse(AlgoliaError.noReachableHosts(intermediateErrors: [],
                                                 exposeIntermediateErrors: false).isCancellation)
  }

  func testOtherErrors() {
    XCTAssertFalse(AlgoliaError.missingData.isCancellation)
    XCTAssertFalse(AlgoliaError.runtimeError("error").isCancellation)
    XCTAssertFalse(AlgoliaError.decodingFailure(SomeError()).isCancellation)
    XCTAssertFalse(SomeError().isCancellation)
  }
}
