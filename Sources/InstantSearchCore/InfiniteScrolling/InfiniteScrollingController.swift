//
//  InfiniteScrollingController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 05/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

class InfiniteScrollingController: InfiniteScrollable {

  public var lastPageIndex: Int?
  public weak var pageLoader: PageLoadable?
  private let pendingPageIndexes: SynchronizedSet<Int>

  public init() {
    pendingPageIndexes = SynchronizedSet()
  }

  public func notifyPending(pageIndex: Int) {
    pendingPageIndexes.remove(pageIndex)
  }

  public func notifyPendingAll() {
    pendingPageIndexes.removeAll()
  }

  internal func isLoadedOrPending<T>(pageIndex: PageMap<T>.PageIndex, pageMap: PageMap<T>) -> Bool {
    let pageIsLoaded = pageMap.containsPage(atIndex: pageIndex)
    let pageIsPending = pendingPageIndexes.contains(pageIndex)
    return pageIsLoaded || pageIsPending
  }

  private func pagesToLoad<T>(in range: [Int], from pageMap: PageMap<T>) -> Set<Int> {
    let pagesContainingRequiredRows = Set(range.map(pageMap.pageIndex(for:)))
    let pagesToLoad = pagesContainingRequiredRows.filter { !isLoadedOrPending(pageIndex: $0, pageMap: pageMap) }
    return pagesToLoad
  }

  func calculatePagesAndLoad<T>(currentRow: Int, offset: Int, pageMap: PageMap<T>) {

    guard let pageLoader = pageLoader else {
      assertionFailure("Missing Page Loader")
      return
    }

    let previousPagesToLoad = computePreviousPagesToLoad(currentRow: currentRow, offset: offset, pageMap: pageMap)

    let nextPagesToLoad = computeNextPagesToLoad(currentRow: currentRow, offset: offset, pageMap: pageMap)

    let pagesToLoad = previousPagesToLoad.union(nextPagesToLoad)

    for pageIndex in pagesToLoad {
      pendingPageIndexes.insert(pageIndex)
      pageLoader.loadPage(atIndex: pageIndex)
    }

  }

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
