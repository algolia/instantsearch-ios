//
//  HitsInteractorTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 14/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class HitsInteractorTests: XCTestCase {
  func testConstructionWithExplicitSettings() {
    let vm = HitsInteractor<String>(infiniteScrolling: .off, showItemsOnEmptyQuery: false)

    if case .off = vm.settings.infiniteScrolling {
    } else { XCTFail() }
    XCTAssertFalse(vm.settings.showItemsOnEmptyQuery)

    let vm1 = HitsInteractor<String>(infiniteScrolling: .on(withOffset: 1000), showItemsOnEmptyQuery: true)

    if case let .on(offset) = vm1.settings.infiniteScrolling {
      XCTAssertEqual(offset, 1000)
    } else { XCTFail() }
    XCTAssertTrue(vm1.settings.showItemsOnEmptyQuery)
  }

  func testUpdateAndContent() throws {
    let vm = HitsInteractor<TestRecord<String>>(infiniteScrolling: .off, showItemsOnEmptyQuery: true)

    let hits = ["h1", "h2", "h3"].map(TestRecord.withValue)
    let results = makeSearchResponse(records: hits)

    XCTAssertEqual(vm.numberOfHits(), 0)
    XCTAssertNil(vm.hit(atIndex: 0))

    let exp = expectation(description: "on results updated")

    vm.onResultsUpdated.subscribe(with: self) { _, _ in
      XCTAssertEqual(vm.numberOfHits(), 3)
      XCTAssertEqual(vm.hit(atIndex: 0)?.value, "h1")
      XCTAssertEqual(vm.hit(atIndex: 1)?.value, "h2")
      XCTAssertEqual(vm.hit(atIndex: 2)?.value, "h3")
      exp.fulfill()
    }

    vm.update(results)

    waitForExpectations(timeout: 3, handler: .none)
  }

  func testHitsAppearanceOnEmptyQueryIfDesactivated() {
    let paginator = Paginator<TestRecord<Int>>()

    let hits = (0..<20).map(TestRecord.withValue)
    let results = makeSearchResponse(records: hits)

    let vm = HitsInteractor(
      settings: .init(showItemsOnEmptyQuery: false),
      paginationController: paginator,
      infiniteScrollingController: TestInfiniteScrollingController()
    )

    let exp = expectation(description: "on results updated")

    vm.onResultsUpdated.subscribe(with: self) { _, _ in
      XCTAssertEqual(vm.numberOfHits(), 0)
      exp.fulfill()
    }

    vm.update(results)

    waitForExpectations(timeout: 3, handler: .none)
  }

  func testHitsAppearanceOnEmptyQueryIfActivated() {
    let paginationController = Paginator<TestRecord<Int>>()
    let infiniteScrollingController = TestInfiniteScrollingController()

    let hits = (0..<20).map(TestRecord.withValue)
    let results = makeSearchResponse(records: hits)

    let vm = HitsInteractor(
      settings: .init(showItemsOnEmptyQuery: true),
      paginationController: paginationController,
      infiniteScrollingController: infiniteScrollingController
    )

    let exp = expectation(description: "on results updated")

    vm.onResultsUpdated.subscribe(with: self) { _, _ in
      XCTAssertEqual(vm.numberOfHits(), hits.count)
      exp.fulfill()
    }

    vm.update(results)

    waitForExpectations(timeout: 3, handler: .none)
  }

  func testRawHitAtIndex() throws {
    let paginationController = Paginator<TestRecord<Int>>()
    let infiniteScrollingController = TestInfiniteScrollingController()

    let hits = (0..<20).map(TestRecord.withValue)
    let results = makeSearchResponse(records: hits)

    let vm = HitsInteractor(
      settings: .init(showItemsOnEmptyQuery: true),
      paginationController: paginationController,
      infiniteScrollingController: infiniteScrollingController
    )

    let exp = expectation(description: "on results updated")

    vm.onResultsUpdated.subscribe(with: self) { _, _ in
      do {
        let rawHit = try XCTUnwrap(vm.rawHitAtIndex(5))
        XCTAssertEqual(rawHit["value"] as? NSNumber, 5)
      } catch {
        XCTFail("\(error)")
      }
      exp.fulfill()
    }

    vm.update(results)

    waitForExpectations(timeout: 3, handler: .none)
  }

  func testInfiniteScrollingTriggering() {
    let pc = Paginator<JSON>()

    let page1 = ["i1", "i2", "i3"].map(makeJSONHit)
    pc.pageMap = PageMap([1: page1])

    let isc = TestInfiniteScrollingController()

    let loadPagesTriggered = expectation(description: "load pages triggered")

    let vm = HitsInteractor(
      settings: .init(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true),
      paginationController: pc,
      infiniteScrollingController: isc
    )

    isc.didCalculatePages = { _, _ in
      loadPagesTriggered.fulfill()
    }

    _ = vm.hit(atIndex: 4)

    waitForExpectations(timeout: 2, handler: nil)
  }

  func testChangeQuery() {
    let pc = Paginator<JSON>()

    let page1 = ["i1", "i2", "i3"].map(makeJSONHit)
    pc.pageMap = PageMap([1: page1])

    let isc = TestInfiniteScrollingController()
    isc.pendingPages = [0, 2]

    let vm = HitsInteractor(
      settings: .init(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true),
      paginationController: pc,
      infiniteScrollingController: isc
    )

    let onRequestChangedExpectation = expectation(description: "on request changed")

    vm.onRequestChanged.subscribe(with: self) { _, _ in

      XCTAssertTrue(pc.isInvalidated)
      XCTAssertTrue(isc.pendingPages.isEmpty)

      onRequestChangedExpectation.fulfill()
    }

    vm.notifyQueryChanged()

    waitForExpectations(timeout: 3, handler: nil)
  }

  struct Person: Codable, Equatable {
    let firstName: String
    let lastName: String
  }

  func testCustomJSONDecoder() throws {
    let snakeCaseDecoder = JSONDecoder()
    snakeCaseDecoder.keyDecodingStrategy = .convertFromSnakeCase

    let hitsInteractor = HitsInteractor<Person>(
      settings: .init(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true),
      paginationController: Paginator(),
      infiniteScrollingController: TestInfiniteScrollingController(),
      jsonDecoder: snakeCaseDecoder
    )

    let hits: [SearchHit] = [
      Hit(object: ["objectID": AnyCodable("1"),
                   "first_name": AnyCodable("Jack"),
                   "last_name": AnyCodable("Johnson")]),
      Hit(object: ["objectID": AnyCodable("2"),
                   "first_name": AnyCodable("Helen"),
                   "last_name": AnyCodable("Smith")])
    ]
    var response = makeSearchResponse(hits: hits)
    response.page = 0

    hitsInteractor.update(response)

    let exp = expectation(description: "on results updated")

    hitsInteractor.onResultsUpdated.subscribe(with: self) { _, _ in
      XCTAssertEqual(hitsInteractor.hits.count, 2)
      XCTAssertEqual(hitsInteractor.hit(atIndex: 0), Person(firstName: "Jack", lastName: "Johnson"))
      XCTAssertEqual(hitsInteractor.hit(atIndex: 1), Person(firstName: "Helen", lastName: "Smith"))
      exp.fulfill()
    }

    waitForExpectations(timeout: 5)
  }
}
