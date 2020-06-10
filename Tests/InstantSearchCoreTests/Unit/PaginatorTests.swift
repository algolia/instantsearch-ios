//
//  PaginatorTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 14/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

struct TestPageable<Item>: Pageable {
  typealias PageItem = Item

  var index: Int

  var items: [Item]
}

class TestPageLoaderDelegate: PageLoadable {

  var requestedLoadPage: ((Int) -> Void)?

  func loadPage(atIndex pageIndex: Int) {
    requestedLoadPage?(pageIndex)
  }

}

class PaginatorTests: XCTestCase {

  func toPages<T>(_ tuples: [(index: Int, items: [T])]) -> [PageMap<T>.Page] {
    return tuples.map { PageMap.Page(index: $0.index, items: $0.items) }
  }

  func testProcessing() {

    let paginator = Paginator<String>()

    let p0 = ["i1", "i2", "i3"]
    let p1 = ["i4", "i5", "i6"]

    XCTAssertNil(paginator.pageMap)

    // Adding a first page of dataset

    let page0 = TestPageable(index: 0, items: p0)

    paginator.process(page0)

    guard let pageMap0 = paginator.pageMap else {
      XCTFail("PageMap cannot be nil after page processing")
      return
    }

    XCTAssertEqual(pageMap0.loadedPages, [.init(index: 0, items: p0)])
    XCTAssertEqual(pageMap0.latestPageIndex, page0.index)
    XCTAssertEqual(pageMap0.loadedPagesCount, 1)
    XCTAssertEqual(pageMap0.count, 3)

    // Adding another page for same dataset

    let page1 = TestPageable(index: 1, items: p1)

    paginator.process(page1)

    guard let pageMap1 = paginator.pageMap else {
      XCTFail("PageMap cannot be nil after page processing")
      return
    }

    XCTAssertEqual(pageMap1.loadedPages, toPages([(0, p0), (1, p1)]))
    XCTAssertEqual(pageMap1.latestPageIndex, page1.index)
    XCTAssertEqual(pageMap1.loadedPagesCount, 2)
    XCTAssertEqual(pageMap1.count, 6)

  }

  func testInvalidation() {

    let paginator = Paginator<String>()
    let page0 = TestPageable(index: 0, items: ["i1", "i2", "i3"])
    let page1 = TestPageable(index: 0, items: ["i4", "i5", "i6"])
    paginator.process(page0)
    XCTAssertNotNil(paginator.pageMap)
    XCTAssertEqual(paginator.pageMap?.count, 3)
    XCTAssertFalse(paginator.isInvalidated)
    paginator.invalidate()
    XCTAssertTrue(paginator.isInvalidated)
    paginator.process(page1)
    XCTAssertNotNil(paginator.pageMap)
    XCTAssertEqual(paginator.pageMap?.count, 3)

  }

}
