//
//  InfiniteScrollable.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 07/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

protocol InfiniteScrollable: AnyObject {

  var lastPageIndex: Int? { get set }
  var pageLoader: PageLoadable? { get set }

  func calculatePagesAndLoad<T>(currentRow: Int, offset: Int, pageMap: PageMap<T>)
  func notifyPending(pageIndex: Int)
  func notifyPendingAll()

}
