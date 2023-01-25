//
//  MultiSearcherTests.swift
//
//
//  Created by Vladislav Fitc on 27/10/2022.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class MultiSearcherTests: XCTestCase {
  func testResultsDistribution() {
    let service = TestMultiSearchService()
    let searcher = AbstractMultiSearcher(service: service,
                                         initialRequest: .init())
    let subSearcher = TestMultiSearchComponent()
    subSearcher.requests = ["req1", "req2"]
    let anotherSubSearcher = TestMultiSearchComponent()
    anotherSubSearcher.requests = ["req3", "req4", "req5"]
    searcher.addSearcher(subSearcher)
    searcher.addSearcher(anotherSubSearcher)

    subSearcher.completion = { result in
      switch result {
      case let .success(results):
        XCTAssertEqual(results, ["res1", "res2"])
      case let .failure(error):
        XCTFail("Unexpected error: \(error)")
      }
    }

    anotherSubSearcher.completion = { result in
      switch result {
      case .failure(MultiSearchError.resultsRangeMismatch(2..<5, 0..<4)):
        break
      case let .failure(error):
        XCTFail("Unexpected error: \(error)")
      case let .success(results):
        XCTFail("Unexpected success \(results)")
      }
    }

    let (_, completion) = searcher.collect()

    completion(.success(["res1", "res2", "res3", "res4"]))
  }
}

struct TestMultiRequest: MultiRequest {
  var subRequests: [String]

  init(subRequests: [String] = []) {
    self.subRequests = subRequests
  }
}

struct TestMultiResult: MultiResult {
  var subResults: [String]

  init(subResults: [String] = []) {
    self.subResults = subResults
  }
}

class TestMultiSearchComponent: MultiSearchComponent {
  var requests: [String] = []
  var completion: (Result<[String], Error>) -> Void = { _ in }

  init() {}

  func collect() -> (requests: [String], completion: (Result<[String], Error>) -> Void) {
    return (requests: requests, completion: completion)
  }
}

class TestMultiSearchService: MultiSearchService {
  func search(_: TestMultiRequest, completion _: @escaping (Swift.Result<TestMultiResult, Error>) -> Void) -> Operation {
    return Operation()
  }
}
