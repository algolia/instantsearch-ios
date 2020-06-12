//
//  InfiniteScrollingControllerTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 05/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class InfiniteScrollingControllerTests: XCTestCase {

  func testPreviousPagesComputation() {

    let isc = InfiniteScrollingController()

    let pageMap = PageMap<String>([1: ["i1", "i2", "i3"]])!

    let previousPagesToLoad = isc.computePreviousPagesToLoad(currentRow: 5, offset: 3, pageMap: pageMap)

    XCTAssertEqual(previousPagesToLoad, [0])

  }

  func testPreviousPagesComputation_NoPage() {

    let isc = InfiniteScrollingController()

    let pageMap = PageMap<String>([1: ["i1", "i2", "i3"]])!

    let previousPagesToLoad = isc.computePreviousPagesToLoad(currentRow: 5, offset: 2, pageMap: pageMap)

    XCTAssertTrue(previousPagesToLoad.isEmpty)

  }

  func testPreviousPagesComputation_Negative() {

    let isc = InfiniteScrollingController()

    let pageMap = PageMap<String>([0: ["i1", "i2", "i3"]])!

    let previousPagesToLoad = isc.computePreviousPagesToLoad(currentRow: 1, offset: 2, pageMap: pageMap)

    XCTAssertTrue(previousPagesToLoad.isEmpty)

  }

  func testPreviousPagesComputation_PageLoaded() {

    let isc = InfiniteScrollingController()

    let pageMap = PageMap<String>([0: ["a1", "a2", "a3"], 1: ["i1", "i2", "i3"]])!

    let previousPagesToLoad = isc.computePreviousPagesToLoad(currentRow: 3, offset: 2, pageMap: pageMap)

    XCTAssertTrue(previousPagesToLoad.isEmpty)

  }

  func testPreviousPagesComputation_MultiplePagesMissing() {

    let isc = InfiniteScrollingController()

    let pageMap = PageMap<String>([
      2: ["d1", "d2", "d3"]
    ])!

    let previousPagesToLoad = isc.computePreviousPagesToLoad(currentRow: 6, offset: 5, pageMap: pageMap)

    XCTAssertEqual(previousPagesToLoad, [0, 1])

  }

  func testPreviousPagesComputation_PreviousPagesPartiallyLoaded() {

    let isc = InfiniteScrollingController()

    let pageMap = PageMap<String>([
      1: ["i1", "i2", "i3"],
      2: ["d1", "d2", "d3"]
    ])!

    let previousPagesToLoad = isc.computePreviousPagesToLoad(currentRow: 6, offset: 5, pageMap: pageMap)

    XCTAssertEqual(previousPagesToLoad, [0])

  }

  func testPreviousPagesComputation_PreviousPagesPartiallyLoadedWithHole() {

    let isc = InfiniteScrollingController()

    let pageMap = PageMap<String>([
      0: ["a1", "a2", "a3"],
      2: ["d1", "d2", "d3"]
    ])!

    let previousPagesToLoad = isc.computePreviousPagesToLoad(currentRow: 6, offset: 5, pageMap: pageMap)

    XCTAssertEqual(previousPagesToLoad, [1])

  }

  func testNextPageComputation() {

    let isc = InfiniteScrollingController()

    let pageMap = PageMap<String>([1: ["i1", "i2", "i3"]])!

    let nextPageIndex = isc.computeNextPagesToLoad(currentRow: 5, offset: 3, pageMap: pageMap)

    XCTAssertEqual(nextPageIndex, [2])

  }

  func testNextPagesComputation_NoPage() {

    let isc = InfiniteScrollingController()

    let pageMap = PageMap<String>([1: ["i1", "i2", "i3"]])!

    let nextPagesToLoad = isc.computeNextPagesToLoad(currentRow: 3, offset: 2, pageMap: pageMap)

    XCTAssertTrue(nextPagesToLoad.isEmpty)

  }

  func testNextPagesComputation_OnLastPage() {

    let isc = InfiniteScrollingController()
    isc.lastPageIndex = 1

    let pageMap = PageMap<String>([1: ["i1", "i2", "i3"]])!

    let nextPagesToLoad = isc.computeNextPagesToLoad(currentRow: 5, offset: 2, pageMap: pageMap)

    XCTAssertTrue(nextPagesToLoad.isEmpty)

  }

  func testNextPagesComputation_NextPageLoaded() {

    let isc = InfiniteScrollingController()

    let pageMap = PageMap<String>([0: ["a1", "a2", "a3"], 1: ["i1", "i2", "i3"]])!

    let nextPagesToLoad = isc.computeNextPagesToLoad(currentRow: 1, offset: 2, pageMap: pageMap)

    XCTAssertTrue(nextPagesToLoad.isEmpty)

  }

  func testNextPagesComputation_MultiplePagesMissing() {

    let isc = InfiniteScrollingController()
    isc.lastPageIndex = 3

    let pageMap = PageMap<String>([
      0: ["a1", "a2", "a3"] ,
      1: ["i1", "i2", "i3"]
    ])!

    let nextPagesToLoad = isc.computeNextPagesToLoad(currentRow: 5, offset: 5, pageMap: pageMap)

    XCTAssertEqual(nextPagesToLoad, [2, 3])

  }

  func testNextPagesComputation_NextPagesPartiallyLoaded() {

    let isc = InfiniteScrollingController()
    isc.lastPageIndex = 2

    let pageMap = PageMap<String>([
      0: ["a1", "a2", "a3"] ,
      1: ["i1", "i2", "i3"]
    ])!

    let nextPagesToLoad = isc.computeNextPagesToLoad(currentRow: 5, offset: 2, pageMap: pageMap)

    XCTAssertEqual(nextPagesToLoad, [2])

  }

  func testNextPagesComputation_NextPagesPartiallyLoadedWithHole() {

    let isc = InfiniteScrollingController()
    isc.lastPageIndex = 3

    let pageMap = PageMap<String>([
      0: ["a1", "a2", "a3"] ,
      1: ["i1", "i2", "i3"],
      3: ["d1", "d2"]
      ])!

    let nextPagesToLoad = isc.computeNextPagesToLoad(currentRow: 5, offset: 10, pageMap: pageMap)

    XCTAssertEqual(nextPagesToLoad, [2])

  }

  func testNotifyLoading() {

    let isc = InfiniteScrollingController()
    let pageLoader = TestPageLoader()
    isc.pageLoader = pageLoader

    let pageMap = PageMap<String>([
      1: ["i1", "i2", "i3"]
    ])!

    XCTAssertFalse(isc.isLoadedOrPending(pageIndex: 0, pageMap: pageMap))
    XCTAssertTrue(isc.isLoadedOrPending(pageIndex: 1, pageMap: pageMap))
    XCTAssertFalse(isc.isLoadedOrPending(pageIndex: 2, pageMap: pageMap))

    isc.calculatePagesAndLoad(currentRow: 4, offset: 2, pageMap: pageMap)

    XCTAssertTrue(isc.isLoadedOrPending(pageIndex: 0, pageMap: pageMap))
    XCTAssertTrue(isc.isLoadedOrPending(pageIndex: 1, pageMap: pageMap))
    XCTAssertTrue(isc.isLoadedOrPending(pageIndex: 2, pageMap: pageMap))

    isc.notifyPending(pageIndex: 0)

    XCTAssertFalse(isc.isLoadedOrPending(pageIndex: 0, pageMap: pageMap))
    XCTAssertTrue(isc.isLoadedOrPending(pageIndex: 1, pageMap: pageMap))
    XCTAssertTrue(isc.isLoadedOrPending(pageIndex: 2, pageMap: pageMap))

    isc.notifyPending(pageIndex: 2)

    XCTAssertFalse(isc.isLoadedOrPending(pageIndex: 0, pageMap: pageMap))
    XCTAssertTrue(isc.isLoadedOrPending(pageIndex: 1, pageMap: pageMap))
    XCTAssertFalse(isc.isLoadedOrPending(pageIndex: 2, pageMap: pageMap))

    isc.calculatePagesAndLoad(currentRow: 4, offset: 2, pageMap: pageMap)

    isc.notifyPendingAll()

    XCTAssertFalse(isc.isLoadedOrPending(pageIndex: 0, pageMap: pageMap))
    XCTAssertTrue(isc.isLoadedOrPending(pageIndex: 1, pageMap: pageMap))
    XCTAssertFalse(isc.isLoadedOrPending(pageIndex: 2, pageMap: pageMap))

  }

}
