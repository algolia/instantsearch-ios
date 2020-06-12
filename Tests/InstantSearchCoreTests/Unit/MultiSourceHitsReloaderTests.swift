//
//  MultiSearchConnectionTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 11/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class TestResultUpdatable: ResultUpdatable {

  var results: [Int]

  var onResultsUpdated: Observer<[Int]>

  init() {
    self.results = []
    self.onResultsUpdated = .init()
  }

  @discardableResult func update(_ results: [Int]) -> Operation {
    self.results = results
    onResultsUpdated.fire(results)
    return .init()
  }

}

class MultiSourceHitsReloaderTests: XCTestCase {

  func testUpdate() {

    let interactor1 = TestResultUpdatable()
    let results1 = [1, 2, 3]

    let interactor2 = TestResultUpdatable()
    let results2 = [4, 5, 6]

    let interactor3 = TestResultUpdatable()
    let results3 = [7, 8, 9]

    let controller = TestHitsController<Int>()

    let connection = MultiSourceReloadNotifier(target: controller)

    connection.register(interactor1)
    connection.register(interactor2)
    connection.register(interactor3)

    let reloadExpectation = expectation(description: "Reload")

    controller.didReload = {
      interactor1.results = results1
      interactor2.results = results2
      interactor3.results = results3
      reloadExpectation.fulfill()
    }

    connection.notifyReload()

    let operationQueue = OperationQueue()

    let operations = zip([interactor1, interactor2, interactor3], [results1, results2, results3]).map { (i, r) in BlockOperation { i.update(r) } }

    operationQueue.addOperations(operations, waitUntilFinished: false)

    waitForExpectations(timeout: 10, handler: .none)

  }

}
