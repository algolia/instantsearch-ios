//
//  Pagination.swift
//  InstantSearchCore-iOS
//
//  Created by Vladislav Fitc on 13/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

class Paginator<Item> {

  var pageMap: PageMap<Item>?
  var pageCleanUpOffset: Int? = 3
  var isInvalidated: Bool = false

  func process<IP: Pageable>(_ page: IP) where IP.Item == Item {

    InstantSearchCoreLogger.trace("InfiniteScrolling: insert page \(page.index)")

    let updatedPageMap: PageMap<Item>?

    if let pageMap = pageMap, !isInvalidated {
      updatedPageMap = pageMap.inserting(page.items, withIndex: page.index)
    } else {
      updatedPageMap = PageMap(page)
      isInvalidated = false
    }

    pageMap = updatedPageMap

    if let pageCleanUpOffset = pageCleanUpOffset {
      pageMap?.cleanUp(basePageIndex: page.index, keepingPagesOffset: pageCleanUpOffset)
    }

  }

  public func invalidate() {
    isInvalidated = true
  }

}
