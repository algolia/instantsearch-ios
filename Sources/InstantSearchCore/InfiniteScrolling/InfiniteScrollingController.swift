//
//  InfiniteScrollingController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 05/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

class InfiniteScrollingController: InfiniteScrollable {

  /// Index of the last page. If equals to `nil`, this index is unknown
  public var lastPageIndex: Int?

  /// Logic triggering the loading of a page
  public weak var pageLoader: PageLoadable?

  /// Set containing the indices of pending pages
  private let pendingPageIndexes: SynchronizedSet<Int>

  public init() {
    pendingPageIndexes = SynchronizedSet()
  }

  /// Remove a page index from a pending set
  public func notifyPending(pageIndex: Int) {
    InstantSearchCoreLogger.trace("InfiniteScrolling: remove page from pending: \(pageIndex)")
    pendingPageIndexes.remove(pageIndex)
  }

  /// Remove all pages from a pending set
  public func notifyPendingAll() {
    InstantSearchCoreLogger.trace("InfiniteScrolling: remove all pages from pending")
    pendingPageIndexes.removeAll()
  }

  /// Returns true if the page at provided index is already loaded or is pending
  internal func isLoadedOrPending<T>(pageIndex: PageMap<T>.PageIndex, pageMap: PageMap<T>) -> Bool {
    let pageIsLoaded = pageMap.containsPage(atIndex: pageIndex)
    let pageIsPending = pendingPageIndexes.contains(pageIndex)
    return pageIsLoaded || pageIsPending
  }

  /// Returns the list of pages indices required for a provided items indices range in the provided PageMap
  private func pagesToLoad<T>(in range: [Int], from pageMap: PageMap<T>) -> Set<Int> {
    let pagesContainingRequiredRows = Set(range.map(pageMap.pageIndex(for:)))
    let pagesToLoad = pagesContainingRequiredRows.filter { !isLoadedOrPending(pageIndex: $0, pageMap: pageMap) }
    return pagesToLoad
  }

  /// Calculates and triggers loading of pages (if necessary) containing all the items in the range (currentRow - offset ... currentRow + offset)
  func calculatePagesAndLoad<T>(currentRow: Int, offset: Int, pageMap: PageMap<T>) {

    guard let pageLoader = pageLoader else {
      assertionFailure("Missing Page Loader")
      return
    }

    let previousPagesToLoad = computePreviousPagesToLoad(currentRow: currentRow, offset: offset, pageMap: pageMap)
    let nextPagesToLoad = computeNextPagesToLoad(currentRow: currentRow, offset: offset, pageMap: pageMap)

    let pagesToLoad = previousPagesToLoad.union(nextPagesToLoad)

    InstantSearchCoreLogger.trace("InfiniteScrolling: required rows: \(currentRow)±\(offset), pages to load: \(pagesToLoad.sorted())")

    for pageIndex in pagesToLoad {
      pendingPageIndexes.insert(pageIndex)
      pageLoader.loadPage(atIndex: pageIndex)
    }

  }

  /// Calculates the pages indices containing all the items in the range (currentRow - offset ... currentRow)
  func computePreviousPagesToLoad<T>(currentRow: Int, offset: Int, pageMap: PageMap<T>) -> Set<PageMap<T>.PageIndex> {

    let computedLowerBoundRow = currentRow - offset
    let lowerBoundRow: Int

    if computedLowerBoundRow < pageMap.startIndex {
      lowerBoundRow = pageMap.startIndex
    } else {
      lowerBoundRow = computedLowerBoundRow
    }

    let requiredRows = Array(lowerBoundRow..<currentRow)
    return pagesToLoad(in: requiredRows, from: pageMap)

  }

  /// Calculates the pages indices containing all the items in the range (currentRow ... currentRow + offset)
  func computeNextPagesToLoad<T>(currentRow: Int, offset: Int, pageMap: PageMap<T>) -> Set<PageMap<T>.PageIndex> {

    let computedUpperBoundRow = currentRow + offset

    let upperBoundRow: Int

    if let lastPageIndex = lastPageIndex {
      let lastPageSize = pageMap.page(atIndex: lastPageIndex)?.items.count ?? pageMap.pageSize
      let totalPagesButLastCount = lastPageIndex
      let lastRowIndex = (totalPagesButLastCount * pageMap.pageSize + lastPageSize) - 1
      upperBoundRow = computedUpperBoundRow > lastRowIndex ? lastRowIndex : computedUpperBoundRow
    } else {
      upperBoundRow = computedUpperBoundRow
    }

    let nextRow = currentRow + 1

    guard nextRow <= upperBoundRow else {
      return []
    }

    let requiredRows = Array(nextRow...upperBoundRow)
    return pagesToLoad(in: requiredRows, from: pageMap)

  }

}
