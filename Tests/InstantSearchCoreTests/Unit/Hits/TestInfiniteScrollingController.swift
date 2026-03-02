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

  private let lock = NSLock()
  private var _pendingPages = Set<Int>()

  var pendingPages: Set<Int> {
    get {
      lock.lock()
      defer { lock.unlock() }
      return _pendingPages
    }
    set {
      lock.lock()
      defer { lock.unlock() }
      _pendingPages = newValue
    }
  }

  var didCalculatePages: ((Int, Int) -> Void)?

  func calculatePagesAndLoad<T>(currentRow: Int, offset: Int, pageMap _: PageMap<T>) {
    didCalculatePages?(currentRow, offset)
  }

  func notifyPending(pageIndex: Int) {
    lock.lock()
    defer { lock.unlock() }
    _pendingPages.remove(pageIndex)
  }

  func notifyPendingAll() {
    lock.lock()
    defer { lock.unlock() }
    _pendingPages.removeAll()
  }
}
