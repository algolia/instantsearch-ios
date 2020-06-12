//
//  TestInfiniteScrollingController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore

class TestInfiniteScrollingController: InfiniteScrollable {

  var lastPageIndex: Int?

  var pageLoader: PageLoadable?

  var pendingPages = Set<Int>()

  var didCalculatePages: ((Int, Int) -> Void)?

  func calculatePagesAndLoad<T>(currentRow: Int, offset: Int, pageMap: PageMap<T>) {
    didCalculatePages?(currentRow, offset)
  }

  func notifyPending(pageIndex: Int) {
    pendingPages.remove(pageIndex)
  }

  func notifyPendingAll() {
    pendingPages.removeAll()
  }

}
